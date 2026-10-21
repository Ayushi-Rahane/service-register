import 'web_download.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/utils/dates.dart';
import '../data/local/app_database.dart';
import '../data/repositories/attachment_repository.dart';
import '../data/repositories/billing_repository.dart';
import '../data/repositories/visit_repository.dart';
import '../domain/app_settings.dart';
import '../domain/enums.dart';
import 'pdf/billing_pdfs.dart';
import 'pdf/pdf_kit.dart';
import 'pdf/report_pdfs.dart';

/// A generated document ready to preview / share.
class GeneratedDoc {
  const GeneratedDoc(
    this.fileName,
    this.bytes, {
    this.mimeType = 'application/pdf',
  });
  final String fileName;
  final Uint8List bytes;
  final String mimeType;
}

/// Gathers data and renders invoices, receipts and service reports.
class DocumentService {
  DocumentService({
    required this.db,
    required this.billing,
    required this.visits,
    required this.attachments,
    this.cloudBytes,
  });

  /// Loads an attachment from cloud storage (browser has no local files).
  final Future<Uint8List?> Function(Attachment a)? cloudBytes;

  final AppDatabase db;
  final BillingRepository billing;
  final VisitRepository visits;
  final AttachmentRepository attachments;

  static String safeName(String s) =>
      s.replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_');

  Future<GeneratedDoc> invoice(
    String invoiceId,
    BusinessSettings settings,
  ) async {
    final inv = (await billing.getInvoice(invoiceId))!;
    final items = await billing.items(invoiceId);
    final linked =
        await (db.select(db.serviceVisits)
              ..where((t) => t.invoiceId.equals(invoiceId))
              ..orderBy([(t) => OrderingTerm(expression: t.visitDate)]))
            .get();
    final allocs = await billing.watchInvoiceAllocations(invoiceId).first;
    final bytes = await buildInvoicePdf(
      InvoicePdfData(
        invoice: inv.invoice,
        items: items,
        visits: linked,
        balance: inv.balance,
        payments: [
          for (final a in allocs)
            (a.payment.receiptNo, a.payment.paidOn, a.allocation.amountPaise),
        ],
      ),
      settings,
      await PdfFonts.load(),
    );
    return GeneratedDoc(
      'Invoice_${safeName(inv.invoice.invoiceNo)}.pdf',
      bytes,
    );
  }

  Future<GeneratedDoc> receipt(
    String paymentId,
    BusinessSettings settings,
  ) async {
    final pay = (await billing.getPayment(paymentId))!;
    final company = await (db.select(
      db.companies,
    )..where((t) => t.id.equals(pay.payment.companyId))).getSingle();
    final allocs = await billing.watchPaymentAllocations(paymentId).first;
    final bytes = await buildReceiptPdf(
      ReceiptPdfData(
        payment: pay.payment,
        companyName: company.name,
        companyAddress: [
          company.address,
          company.city,
        ].whereType<String>().join(', '),
        allocations: [
          for (final a in allocs) (a.invoiceNo, a.allocation.amountPaise),
        ],
      ),
      settings,
      await PdfFonts.load(),
    );
    return GeneratedDoc(
      'Receipt_${safeName(pay.payment.receiptNo)}.pdf',
      bytes,
    );
  }

  Future<GeneratedDoc> visitReport(
    String visitId,
    BusinessSettings settings, {
    bool includeCharges = true,
  }) async {
    final v = (await visits.get(visitId))!;
    final company = await (db.select(
      db.companies,
    )..where((t) => t.id.equals(v.companyId))).getSingle();
    final machine = v.machineId == null
        ? null
        : await (db.select(
            db.machines,
          )..where((t) => t.id.equals(v.machineId!))).getSingleOrNull();
    final files = await attachments.watchFor('visit', visitId).first;
    final photos = <(String, Uint8List)>[];
    Uint8List? signature;
    for (final a in files) {
      if (!AttachmentRepository.isImage(a)) continue;
      final Uint8List? bytes;
      if (kIsWeb) {
        bytes = await cloudBytes?.call(a);
      } else {
        bytes = await (await attachments.fileFor(a))?.readAsBytes();
      }
      if (bytes == null) continue;
      if (a.kind == AttachmentKind.signature.db) {
        signature = bytes;
      } else if (!a.fileName.toLowerCase().endsWith('.heic')) {
        photos.add((a.caption ?? AttachmentKind.fromDb(a.kind).label, bytes));
      }
    }
    final bytes = await buildVisitReportPdf(
      VisitReportData(
        visit: v,
        company: company,
        machine: machine,
        parts: await visits.parts(visitId),
        photos: photos,
        signature: signature,
        includeCharges: includeCharges,
      ),
      settings,
      await PdfFonts.load(),
    );
    return GeneratedDoc('ServiceReport_${safeName(v.visitNo)}.pdf', bytes);
  }

  /// Writes [doc] to a temporary file and opens the system share sheet
  /// (WhatsApp, email, Drive, ...).
  static Future<void> share(GeneratedDoc doc, {String? text}) async {
    if (kIsWeb) {
      // In a browser the file is downloaded; attach it to WhatsApp Web /
      // email from the Downloads folder.
      return downloadBytes(doc.bytes, doc.fileName, doc.mimeType);
    }
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, doc.fileName));
    await file.writeAsBytes(doc.bytes, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: doc.mimeType, name: doc.fileName)],
        text: text,
        subject: doc.fileName,
      ),
    );
  }

  /// Saves a copy in the app's private "exports" folder. Returns the path.
  /// (To put a file in Downloads / Files / Drive, use [share].)
  static Future<String> saveCopy(GeneratedDoc doc) async {
    if (kIsWeb) {
      await downloadBytes(doc.bytes, doc.fileName, doc.mimeType);
      return 'your Downloads folder';
    }
    final dir = Directory(
      p.join((await getApplicationDocumentsDirectory()).path, 'exports'),
    );
    await dir.create(recursive: true);
    final file = File(p.join(dir.path, doc.fileName));
    await file.writeAsBytes(doc.bytes, flush: true);
    return file.path;
  }

  static String stamp() => Dates.today();
}
