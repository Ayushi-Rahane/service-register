// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CompaniesTable extends Companies
    with TableInfo<$CompaniesTable, Company> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompaniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactPersonMeta = const VerificationMeta(
    'contactPerson',
  );
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
    'contact_person',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altPhoneMeta = const VerificationMeta(
    'altPhone',
  );
  @override
  late final GeneratedColumn<String> altPhone = GeneratedColumn<String>(
    'alt_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pincodeMeta = const VerificationMeta(
    'pincode',
  );
  @override
  late final GeneratedColumn<String> pincode = GeneratedColumn<String>(
    'pincode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
    'gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    code,
    name,
    contactPerson,
    phone,
    altPhone,
    email,
    address,
    city,
    state,
    pincode,
    gstin,
    notes,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'companies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Company> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contact_person')) {
      context.handle(
        _contactPersonMeta,
        contactPerson.isAcceptableOrUnknown(
          data['contact_person']!,
          _contactPersonMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('alt_phone')) {
      context.handle(
        _altPhoneMeta,
        altPhone.isAcceptableOrUnknown(data['alt_phone']!, _altPhoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('pincode')) {
      context.handle(
        _pincodeMeta,
        pincode.isAcceptableOrUnknown(data['pincode']!, _pincodeMeta),
      );
    }
    if (data.containsKey('gstin')) {
      context.handle(
        _gstinMeta,
        gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Company map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Company(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      contactPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      altPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alt_phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      pincode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pincode'],
      ),
      gstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gstin'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $CompaniesTable createAlias(String alias) {
    return $CompaniesTable(attachedDatabase, alias);
  }
}

class Company extends DataClass implements Insertable<Company> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String? code;
  final String name;
  final String? contactPerson;
  final String? phone;
  final String? altPhone;
  final String? email;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? gstin;
  final String? notes;
  final DateTime? archivedAt;
  const Company({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    this.code,
    required this.name,
    this.contactPerson,
    this.phone,
    this.altPhone,
    this.email,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.gstin,
    this.notes,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || contactPerson != null) {
      map['contact_person'] = Variable<String>(contactPerson);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || altPhone != null) {
      map['alt_phone'] = Variable<String>(altPhone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || pincode != null) {
      map['pincode'] = Variable<String>(pincode);
    }
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  CompaniesCompanion toCompanion(bool nullToAbsent) {
    return CompaniesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      name: Value(name),
      contactPerson: contactPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPerson),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      altPhone: altPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(altPhone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      pincode: pincode == null && nullToAbsent
          ? const Value.absent()
          : Value(pincode),
      gstin: gstin == null && nullToAbsent
          ? const Value.absent()
          : Value(gstin),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Company.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Company(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      code: serializer.fromJson<String?>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      contactPerson: serializer.fromJson<String?>(json['contactPerson']),
      phone: serializer.fromJson<String?>(json['phone']),
      altPhone: serializer.fromJson<String?>(json['altPhone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      pincode: serializer.fromJson<String?>(json['pincode']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      notes: serializer.fromJson<String?>(json['notes']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'code': serializer.toJson<String?>(code),
      'name': serializer.toJson<String>(name),
      'contactPerson': serializer.toJson<String?>(contactPerson),
      'phone': serializer.toJson<String?>(phone),
      'altPhone': serializer.toJson<String?>(altPhone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'pincode': serializer.toJson<String?>(pincode),
      'gstin': serializer.toJson<String?>(gstin),
      'notes': serializer.toJson<String?>(notes),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Company copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    Value<String?> code = const Value.absent(),
    String? name,
    Value<String?> contactPerson = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> altPhone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> pincode = const Value.absent(),
    Value<String?> gstin = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => Company(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    code: code.present ? code.value : this.code,
    name: name ?? this.name,
    contactPerson: contactPerson.present
        ? contactPerson.value
        : this.contactPerson,
    phone: phone.present ? phone.value : this.phone,
    altPhone: altPhone.present ? altPhone.value : this.altPhone,
    email: email.present ? email.value : this.email,
    address: address.present ? address.value : this.address,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
    pincode: pincode.present ? pincode.value : this.pincode,
    gstin: gstin.present ? gstin.value : this.gstin,
    notes: notes.present ? notes.value : this.notes,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  Company copyWithCompanion(CompaniesCompanion data) {
    return Company(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
      phone: data.phone.present ? data.phone.value : this.phone,
      altPhone: data.altPhone.present ? data.altPhone.value : this.altPhone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      pincode: data.pincode.present ? data.pincode.value : this.pincode,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      notes: data.notes.present ? data.notes.value : this.notes,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Company(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phone: $phone, ')
          ..write('altPhone: $altPhone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('pincode: $pincode, ')
          ..write('gstin: $gstin, ')
          ..write('notes: $notes, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    code,
    name,
    contactPerson,
    phone,
    altPhone,
    email,
    address,
    city,
    state,
    pincode,
    gstin,
    notes,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Company &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.code == this.code &&
          other.name == this.name &&
          other.contactPerson == this.contactPerson &&
          other.phone == this.phone &&
          other.altPhone == this.altPhone &&
          other.email == this.email &&
          other.address == this.address &&
          other.city == this.city &&
          other.state == this.state &&
          other.pincode == this.pincode &&
          other.gstin == this.gstin &&
          other.notes == this.notes &&
          other.archivedAt == this.archivedAt);
}

class CompaniesCompanion extends UpdateCompanion<Company> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String?> code;
  final Value<String> name;
  final Value<String?> contactPerson;
  final Value<String?> phone;
  final Value<String?> altPhone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> pincode;
  final Value<String?> gstin;
  final Value<String?> notes;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const CompaniesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.phone = const Value.absent(),
    this.altPhone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.pincode = const Value.absent(),
    this.gstin = const Value.absent(),
    this.notes = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompaniesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    this.code = const Value.absent(),
    required String name,
    this.contactPerson = const Value.absent(),
    this.phone = const Value.absent(),
    this.altPhone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.pincode = const Value.absent(),
    this.gstin = const Value.absent(),
    this.notes = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<Company> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? contactPerson,
    Expression<String>? phone,
    Expression<String>? altPhone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? pincode,
    Expression<String>? gstin,
    Expression<String>? notes,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (phone != null) 'phone': phone,
      if (altPhone != null) 'alt_phone': altPhone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (pincode != null) 'pincode': pincode,
      if (gstin != null) 'gstin': gstin,
      if (notes != null) 'notes': notes,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompaniesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String?>? code,
    Value<String>? name,
    Value<String?>? contactPerson,
    Value<String?>? phone,
    Value<String?>? altPhone,
    Value<String?>? email,
    Value<String?>? address,
    Value<String?>? city,
    Value<String?>? state,
    Value<String?>? pincode,
    Value<String?>? gstin,
    Value<String?>? notes,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return CompaniesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      code: code ?? this.code,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      gstin: gstin ?? this.gstin,
      notes: notes ?? this.notes,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (altPhone.present) {
      map['alt_phone'] = Variable<String>(altPhone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (pincode.present) {
      map['pincode'] = Variable<String>(pincode.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompaniesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phone: $phone, ')
          ..write('altPhone: $altPhone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('pincode: $pincode, ')
          ..write('gstin: $gstin, ')
          ..write('notes: $notes, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MachinesTable extends Machines with TableInfo<$MachinesTable, Machine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MachinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _manufacturerMeta = const VerificationMeta(
    'manufacturer',
  );
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
    'manufacturer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialNumberMeta = const VerificationMeta(
    'serialNumber',
  );
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
    'serial_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _installedOnMeta = const VerificationMeta(
    'installedOn',
  );
  @override
  late final GeneratedColumn<String> installedOn = GeneratedColumn<String>(
    'installed_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warrantyUntilMeta = const VerificationMeta(
    'warrantyUntil',
  );
  @override
  late final GeneratedColumn<String> warrantyUntil = GeneratedColumn<String>(
    'warranty_until',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serviceIntervalDaysMeta =
      const VerificationMeta('serviceIntervalDays');
  @override
  late final GeneratedColumn<int> serviceIntervalDays = GeneratedColumn<int>(
    'service_interval_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextServiceDueMeta = const VerificationMeta(
    'nextServiceDue',
  );
  @override
  late final GeneratedColumn<String> nextServiceDue = GeneratedColumn<String>(
    'next_service_due',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('operational'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    companyId,
    name,
    category,
    manufacturer,
    model,
    serialNumber,
    location,
    installedOn,
    warrantyUntil,
    serviceIntervalDays,
    nextServiceDue,
    status,
    notes,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'machines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Machine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
        _manufacturerMeta,
        manufacturer.isAcceptableOrUnknown(
          data['manufacturer']!,
          _manufacturerMeta,
        ),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('serial_number')) {
      context.handle(
        _serialNumberMeta,
        serialNumber.isAcceptableOrUnknown(
          data['serial_number']!,
          _serialNumberMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('installed_on')) {
      context.handle(
        _installedOnMeta,
        installedOn.isAcceptableOrUnknown(
          data['installed_on']!,
          _installedOnMeta,
        ),
      );
    }
    if (data.containsKey('warranty_until')) {
      context.handle(
        _warrantyUntilMeta,
        warrantyUntil.isAcceptableOrUnknown(
          data['warranty_until']!,
          _warrantyUntilMeta,
        ),
      );
    }
    if (data.containsKey('service_interval_days')) {
      context.handle(
        _serviceIntervalDaysMeta,
        serviceIntervalDays.isAcceptableOrUnknown(
          data['service_interval_days']!,
          _serviceIntervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('next_service_due')) {
      context.handle(
        _nextServiceDueMeta,
        nextServiceDue.isAcceptableOrUnknown(
          data['next_service_due']!,
          _nextServiceDueMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Machine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Machine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      manufacturer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      serialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_number'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      installedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installed_on'],
      ),
      warrantyUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}warranty_until'],
      ),
      serviceIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_interval_days'],
      ),
      nextServiceDue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_service_due'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $MachinesTable createAlias(String alias) {
    return $MachinesTable(attachedDatabase, alias);
  }
}

class Machine extends DataClass implements Insertable<Machine> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String companyId;
  final String name;
  final String category;
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final String? location;
  final String? installedOn;
  final String? warrantyUntil;
  final int? serviceIntervalDays;
  final String? nextServiceDue;
  final String status;
  final String? notes;
  final DateTime? archivedAt;
  const Machine({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.companyId,
    required this.name,
    required this.category,
    this.manufacturer,
    this.model,
    this.serialNumber,
    this.location,
    this.installedOn,
    this.warrantyUntil,
    this.serviceIntervalDays,
    this.nextServiceDue,
    required this.status,
    this.notes,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['company_id'] = Variable<String>(companyId);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || serialNumber != null) {
      map['serial_number'] = Variable<String>(serialNumber);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || installedOn != null) {
      map['installed_on'] = Variable<String>(installedOn);
    }
    if (!nullToAbsent || warrantyUntil != null) {
      map['warranty_until'] = Variable<String>(warrantyUntil);
    }
    if (!nullToAbsent || serviceIntervalDays != null) {
      map['service_interval_days'] = Variable<int>(serviceIntervalDays);
    }
    if (!nullToAbsent || nextServiceDue != null) {
      map['next_service_due'] = Variable<String>(nextServiceDue);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  MachinesCompanion toCompanion(bool nullToAbsent) {
    return MachinesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      companyId: Value(companyId),
      name: Value(name),
      category: Value(category),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      serialNumber: serialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(serialNumber),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      installedOn: installedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(installedOn),
      warrantyUntil: warrantyUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(warrantyUntil),
      serviceIntervalDays: serviceIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceIntervalDays),
      nextServiceDue: nextServiceDue == null && nullToAbsent
          ? const Value.absent()
          : Value(nextServiceDue),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Machine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Machine(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      companyId: serializer.fromJson<String>(json['companyId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      model: serializer.fromJson<String?>(json['model']),
      serialNumber: serializer.fromJson<String?>(json['serialNumber']),
      location: serializer.fromJson<String?>(json['location']),
      installedOn: serializer.fromJson<String?>(json['installedOn']),
      warrantyUntil: serializer.fromJson<String?>(json['warrantyUntil']),
      serviceIntervalDays: serializer.fromJson<int?>(
        json['serviceIntervalDays'],
      ),
      nextServiceDue: serializer.fromJson<String?>(json['nextServiceDue']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'companyId': serializer.toJson<String>(companyId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'model': serializer.toJson<String?>(model),
      'serialNumber': serializer.toJson<String?>(serialNumber),
      'location': serializer.toJson<String?>(location),
      'installedOn': serializer.toJson<String?>(installedOn),
      'warrantyUntil': serializer.toJson<String?>(warrantyUntil),
      'serviceIntervalDays': serializer.toJson<int?>(serviceIntervalDays),
      'nextServiceDue': serializer.toJson<String?>(nextServiceDue),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Machine copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? companyId,
    String? name,
    String? category,
    Value<String?> manufacturer = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<String?> serialNumber = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> installedOn = const Value.absent(),
    Value<String?> warrantyUntil = const Value.absent(),
    Value<int?> serviceIntervalDays = const Value.absent(),
    Value<String?> nextServiceDue = const Value.absent(),
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => Machine(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    companyId: companyId ?? this.companyId,
    name: name ?? this.name,
    category: category ?? this.category,
    manufacturer: manufacturer.present ? manufacturer.value : this.manufacturer,
    model: model.present ? model.value : this.model,
    serialNumber: serialNumber.present ? serialNumber.value : this.serialNumber,
    location: location.present ? location.value : this.location,
    installedOn: installedOn.present ? installedOn.value : this.installedOn,
    warrantyUntil: warrantyUntil.present
        ? warrantyUntil.value
        : this.warrantyUntil,
    serviceIntervalDays: serviceIntervalDays.present
        ? serviceIntervalDays.value
        : this.serviceIntervalDays,
    nextServiceDue: nextServiceDue.present
        ? nextServiceDue.value
        : this.nextServiceDue,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  Machine copyWithCompanion(MachinesCompanion data) {
    return Machine(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      model: data.model.present ? data.model.value : this.model,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      location: data.location.present ? data.location.value : this.location,
      installedOn: data.installedOn.present
          ? data.installedOn.value
          : this.installedOn,
      warrantyUntil: data.warrantyUntil.present
          ? data.warrantyUntil.value
          : this.warrantyUntil,
      serviceIntervalDays: data.serviceIntervalDays.present
          ? data.serviceIntervalDays.value
          : this.serviceIntervalDays,
      nextServiceDue: data.nextServiceDue.present
          ? data.nextServiceDue.value
          : this.nextServiceDue,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Machine(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('companyId: $companyId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('model: $model, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('location: $location, ')
          ..write('installedOn: $installedOn, ')
          ..write('warrantyUntil: $warrantyUntil, ')
          ..write('serviceIntervalDays: $serviceIntervalDays, ')
          ..write('nextServiceDue: $nextServiceDue, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    companyId,
    name,
    category,
    manufacturer,
    model,
    serialNumber,
    location,
    installedOn,
    warrantyUntil,
    serviceIntervalDays,
    nextServiceDue,
    status,
    notes,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Machine &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.companyId == this.companyId &&
          other.name == this.name &&
          other.category == this.category &&
          other.manufacturer == this.manufacturer &&
          other.model == this.model &&
          other.serialNumber == this.serialNumber &&
          other.location == this.location &&
          other.installedOn == this.installedOn &&
          other.warrantyUntil == this.warrantyUntil &&
          other.serviceIntervalDays == this.serviceIntervalDays &&
          other.nextServiceDue == this.nextServiceDue &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.archivedAt == this.archivedAt);
}

class MachinesCompanion extends UpdateCompanion<Machine> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> companyId;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> manufacturer;
  final Value<String?> model;
  final Value<String?> serialNumber;
  final Value<String?> location;
  final Value<String?> installedOn;
  final Value<String?> warrantyUntil;
  final Value<int?> serviceIntervalDays;
  final Value<String?> nextServiceDue;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const MachinesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.companyId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.model = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.location = const Value.absent(),
    this.installedOn = const Value.absent(),
    this.warrantyUntil = const Value.absent(),
    this.serviceIntervalDays = const Value.absent(),
    this.nextServiceDue = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MachinesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String companyId,
    required String name,
    this.category = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.model = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.location = const Value.absent(),
    this.installedOn = const Value.absent(),
    this.warrantyUntil = const Value.absent(),
    this.serviceIntervalDays = const Value.absent(),
    this.nextServiceDue = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       companyId = Value(companyId),
       name = Value(name);
  static Insertable<Machine> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? companyId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? manufacturer,
    Expression<String>? model,
    Expression<String>? serialNumber,
    Expression<String>? location,
    Expression<String>? installedOn,
    Expression<String>? warrantyUntil,
    Expression<int>? serviceIntervalDays,
    Expression<String>? nextServiceDue,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (companyId != null) 'company_id': companyId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (location != null) 'location': location,
      if (installedOn != null) 'installed_on': installedOn,
      if (warrantyUntil != null) 'warranty_until': warrantyUntil,
      if (serviceIntervalDays != null)
        'service_interval_days': serviceIntervalDays,
      if (nextServiceDue != null) 'next_service_due': nextServiceDue,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MachinesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? companyId,
    Value<String>? name,
    Value<String>? category,
    Value<String?>? manufacturer,
    Value<String?>? model,
    Value<String?>? serialNumber,
    Value<String?>? location,
    Value<String?>? installedOn,
    Value<String?>? warrantyUntil,
    Value<int?>? serviceIntervalDays,
    Value<String?>? nextServiceDue,
    Value<String>? status,
    Value<String?>? notes,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return MachinesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      category: category ?? this.category,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      location: location ?? this.location,
      installedOn: installedOn ?? this.installedOn,
      warrantyUntil: warrantyUntil ?? this.warrantyUntil,
      serviceIntervalDays: serviceIntervalDays ?? this.serviceIntervalDays,
      nextServiceDue: nextServiceDue ?? this.nextServiceDue,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (installedOn.present) {
      map['installed_on'] = Variable<String>(installedOn.value);
    }
    if (warrantyUntil.present) {
      map['warranty_until'] = Variable<String>(warrantyUntil.value);
    }
    if (serviceIntervalDays.present) {
      map['service_interval_days'] = Variable<int>(serviceIntervalDays.value);
    }
    if (nextServiceDue.present) {
      map['next_service_due'] = Variable<String>(nextServiceDue.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MachinesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('companyId: $companyId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('model: $model, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('location: $location, ')
          ..write('installedOn: $installedOn, ')
          ..write('warrantyUntil: $warrantyUntil, ')
          ..write('serviceIntervalDays: $serviceIntervalDays, ')
          ..write('nextServiceDue: $nextServiceDue, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartsTable extends Parts with TableInfo<$PartsTable, Part> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partNumberMeta = const VerificationMeta(
    'partNumber',
  );
  @override
  late final GeneratedColumn<String> partNumber = GeneratedColumn<String>(
    'part_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pcs'),
  );
  static const VerificationMeta _minStockMilliMeta = const VerificationMeta(
    'minStockMilli',
  );
  @override
  late final GeneratedColumn<int> minStockMilli = GeneratedColumn<int>(
    'min_stock_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _purchasePaiseMeta = const VerificationMeta(
    'purchasePaise',
  );
  @override
  late final GeneratedColumn<int> purchasePaise = GeneratedColumn<int>(
    'purchase_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sellingPaiseMeta = const VerificationMeta(
    'sellingPaise',
  );
  @override
  late final GeneratedColumn<int> sellingPaise = GeneratedColumn<int>(
    'selling_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierNameMeta = const VerificationMeta(
    'supplierName',
  );
  @override
  late final GeneratedColumn<String> supplierName = GeneratedColumn<String>(
    'supplier_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierContactMeta = const VerificationMeta(
    'supplierContact',
  );
  @override
  late final GeneratedColumn<String> supplierContact = GeneratedColumn<String>(
    'supplier_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    name,
    partNumber,
    category,
    unit,
    minStockMilli,
    purchasePaise,
    sellingPaise,
    supplierName,
    supplierContact,
    notes,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Part> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('part_number')) {
      context.handle(
        _partNumberMeta,
        partNumber.isAcceptableOrUnknown(data['part_number']!, _partNumberMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('min_stock_milli')) {
      context.handle(
        _minStockMilliMeta,
        minStockMilli.isAcceptableOrUnknown(
          data['min_stock_milli']!,
          _minStockMilliMeta,
        ),
      );
    }
    if (data.containsKey('purchase_paise')) {
      context.handle(
        _purchasePaiseMeta,
        purchasePaise.isAcceptableOrUnknown(
          data['purchase_paise']!,
          _purchasePaiseMeta,
        ),
      );
    }
    if (data.containsKey('selling_paise')) {
      context.handle(
        _sellingPaiseMeta,
        sellingPaise.isAcceptableOrUnknown(
          data['selling_paise']!,
          _sellingPaiseMeta,
        ),
      );
    }
    if (data.containsKey('supplier_name')) {
      context.handle(
        _supplierNameMeta,
        supplierName.isAcceptableOrUnknown(
          data['supplier_name']!,
          _supplierNameMeta,
        ),
      );
    }
    if (data.containsKey('supplier_contact')) {
      context.handle(
        _supplierContactMeta,
        supplierContact.isAcceptableOrUnknown(
          data['supplier_contact']!,
          _supplierContactMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Part map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Part(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      partNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_number'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      minStockMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_stock_milli'],
      )!,
      purchasePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_paise'],
      ),
      sellingPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_paise'],
      ),
      supplierName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_name'],
      ),
      supplierContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_contact'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }
}

class Part extends DataClass implements Insertable<Part> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String name;
  final String? partNumber;
  final String? category;
  final String unit;
  final int minStockMilli;
  final int? purchasePaise;
  final int? sellingPaise;
  final String? supplierName;
  final String? supplierContact;
  final String? notes;
  final DateTime? archivedAt;
  const Part({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.name,
    this.partNumber,
    this.category,
    required this.unit,
    required this.minStockMilli,
    this.purchasePaise,
    this.sellingPaise,
    this.supplierName,
    this.supplierContact,
    this.notes,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || partNumber != null) {
      map['part_number'] = Variable<String>(partNumber);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['unit'] = Variable<String>(unit);
    map['min_stock_milli'] = Variable<int>(minStockMilli);
    if (!nullToAbsent || purchasePaise != null) {
      map['purchase_paise'] = Variable<int>(purchasePaise);
    }
    if (!nullToAbsent || sellingPaise != null) {
      map['selling_paise'] = Variable<int>(sellingPaise);
    }
    if (!nullToAbsent || supplierName != null) {
      map['supplier_name'] = Variable<String>(supplierName);
    }
    if (!nullToAbsent || supplierContact != null) {
      map['supplier_contact'] = Variable<String>(supplierContact);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      name: Value(name),
      partNumber: partNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(partNumber),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      unit: Value(unit),
      minStockMilli: Value(minStockMilli),
      purchasePaise: purchasePaise == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePaise),
      sellingPaise: sellingPaise == null && nullToAbsent
          ? const Value.absent()
          : Value(sellingPaise),
      supplierName: supplierName == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierName),
      supplierContact: supplierContact == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierContact),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Part.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Part(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      name: serializer.fromJson<String>(json['name']),
      partNumber: serializer.fromJson<String?>(json['partNumber']),
      category: serializer.fromJson<String?>(json['category']),
      unit: serializer.fromJson<String>(json['unit']),
      minStockMilli: serializer.fromJson<int>(json['minStockMilli']),
      purchasePaise: serializer.fromJson<int?>(json['purchasePaise']),
      sellingPaise: serializer.fromJson<int?>(json['sellingPaise']),
      supplierName: serializer.fromJson<String?>(json['supplierName']),
      supplierContact: serializer.fromJson<String?>(json['supplierContact']),
      notes: serializer.fromJson<String?>(json['notes']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'name': serializer.toJson<String>(name),
      'partNumber': serializer.toJson<String?>(partNumber),
      'category': serializer.toJson<String?>(category),
      'unit': serializer.toJson<String>(unit),
      'minStockMilli': serializer.toJson<int>(minStockMilli),
      'purchasePaise': serializer.toJson<int?>(purchasePaise),
      'sellingPaise': serializer.toJson<int?>(sellingPaise),
      'supplierName': serializer.toJson<String?>(supplierName),
      'supplierContact': serializer.toJson<String?>(supplierContact),
      'notes': serializer.toJson<String?>(notes),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Part copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? name,
    Value<String?> partNumber = const Value.absent(),
    Value<String?> category = const Value.absent(),
    String? unit,
    int? minStockMilli,
    Value<int?> purchasePaise = const Value.absent(),
    Value<int?> sellingPaise = const Value.absent(),
    Value<String?> supplierName = const Value.absent(),
    Value<String?> supplierContact = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => Part(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    name: name ?? this.name,
    partNumber: partNumber.present ? partNumber.value : this.partNumber,
    category: category.present ? category.value : this.category,
    unit: unit ?? this.unit,
    minStockMilli: minStockMilli ?? this.minStockMilli,
    purchasePaise: purchasePaise.present
        ? purchasePaise.value
        : this.purchasePaise,
    sellingPaise: sellingPaise.present ? sellingPaise.value : this.sellingPaise,
    supplierName: supplierName.present ? supplierName.value : this.supplierName,
    supplierContact: supplierContact.present
        ? supplierContact.value
        : this.supplierContact,
    notes: notes.present ? notes.value : this.notes,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  Part copyWithCompanion(PartsCompanion data) {
    return Part(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      name: data.name.present ? data.name.value : this.name,
      partNumber: data.partNumber.present
          ? data.partNumber.value
          : this.partNumber,
      category: data.category.present ? data.category.value : this.category,
      unit: data.unit.present ? data.unit.value : this.unit,
      minStockMilli: data.minStockMilli.present
          ? data.minStockMilli.value
          : this.minStockMilli,
      purchasePaise: data.purchasePaise.present
          ? data.purchasePaise.value
          : this.purchasePaise,
      sellingPaise: data.sellingPaise.present
          ? data.sellingPaise.value
          : this.sellingPaise,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      supplierContact: data.supplierContact.present
          ? data.supplierContact.value
          : this.supplierContact,
      notes: data.notes.present ? data.notes.value : this.notes,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Part(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('name: $name, ')
          ..write('partNumber: $partNumber, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('minStockMilli: $minStockMilli, ')
          ..write('purchasePaise: $purchasePaise, ')
          ..write('sellingPaise: $sellingPaise, ')
          ..write('supplierName: $supplierName, ')
          ..write('supplierContact: $supplierContact, ')
          ..write('notes: $notes, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    name,
    partNumber,
    category,
    unit,
    minStockMilli,
    purchasePaise,
    sellingPaise,
    supplierName,
    supplierContact,
    notes,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Part &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.name == this.name &&
          other.partNumber == this.partNumber &&
          other.category == this.category &&
          other.unit == this.unit &&
          other.minStockMilli == this.minStockMilli &&
          other.purchasePaise == this.purchasePaise &&
          other.sellingPaise == this.sellingPaise &&
          other.supplierName == this.supplierName &&
          other.supplierContact == this.supplierContact &&
          other.notes == this.notes &&
          other.archivedAt == this.archivedAt);
}

class PartsCompanion extends UpdateCompanion<Part> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> name;
  final Value<String?> partNumber;
  final Value<String?> category;
  final Value<String> unit;
  final Value<int> minStockMilli;
  final Value<int?> purchasePaise;
  final Value<int?> sellingPaise;
  final Value<String?> supplierName;
  final Value<String?> supplierContact;
  final Value<String?> notes;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.name = const Value.absent(),
    this.partNumber = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    this.minStockMilli = const Value.absent(),
    this.purchasePaise = const Value.absent(),
    this.sellingPaise = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.supplierContact = const Value.absent(),
    this.notes = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String name,
    this.partNumber = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    this.minStockMilli = const Value.absent(),
    this.purchasePaise = const Value.absent(),
    this.sellingPaise = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.supplierContact = const Value.absent(),
    this.notes = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<Part> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? name,
    Expression<String>? partNumber,
    Expression<String>? category,
    Expression<String>? unit,
    Expression<int>? minStockMilli,
    Expression<int>? purchasePaise,
    Expression<int>? sellingPaise,
    Expression<String>? supplierName,
    Expression<String>? supplierContact,
    Expression<String>? notes,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (name != null) 'name': name,
      if (partNumber != null) 'part_number': partNumber,
      if (category != null) 'category': category,
      if (unit != null) 'unit': unit,
      if (minStockMilli != null) 'min_stock_milli': minStockMilli,
      if (purchasePaise != null) 'purchase_paise': purchasePaise,
      if (sellingPaise != null) 'selling_paise': sellingPaise,
      if (supplierName != null) 'supplier_name': supplierName,
      if (supplierContact != null) 'supplier_contact': supplierContact,
      if (notes != null) 'notes': notes,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? name,
    Value<String?>? partNumber,
    Value<String?>? category,
    Value<String>? unit,
    Value<int>? minStockMilli,
    Value<int?>? purchasePaise,
    Value<int?>? sellingPaise,
    Value<String?>? supplierName,
    Value<String?>? supplierContact,
    Value<String?>? notes,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return PartsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      name: name ?? this.name,
      partNumber: partNumber ?? this.partNumber,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      minStockMilli: minStockMilli ?? this.minStockMilli,
      purchasePaise: purchasePaise ?? this.purchasePaise,
      sellingPaise: sellingPaise ?? this.sellingPaise,
      supplierName: supplierName ?? this.supplierName,
      supplierContact: supplierContact ?? this.supplierContact,
      notes: notes ?? this.notes,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (partNumber.present) {
      map['part_number'] = Variable<String>(partNumber.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (minStockMilli.present) {
      map['min_stock_milli'] = Variable<int>(minStockMilli.value);
    }
    if (purchasePaise.present) {
      map['purchase_paise'] = Variable<int>(purchasePaise.value);
    }
    if (sellingPaise.present) {
      map['selling_paise'] = Variable<int>(sellingPaise.value);
    }
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
    }
    if (supplierContact.present) {
      map['supplier_contact'] = Variable<String>(supplierContact.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('name: $name, ')
          ..write('partNumber: $partNumber, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('minStockMilli: $minStockMilli, ')
          ..write('purchasePaise: $purchasePaise, ')
          ..write('sellingPaise: $sellingPaise, ')
          ..write('supplierName: $supplierName, ')
          ..write('supplierContact: $supplierContact, ')
          ..write('notes: $notes, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceVisitsTable extends ServiceVisits
    with TableInfo<$ServiceVisitsTable, ServiceVisit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceVisitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _visitNoMeta = const VerificationMeta(
    'visitNo',
  );
  @override
  late final GeneratedColumn<String> visitNo = GeneratedColumn<String>(
    'visit_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id)',
    ),
  );
  static const VerificationMeta _machineIdMeta = const VerificationMeta(
    'machineId',
  );
  @override
  late final GeneratedColumn<String> machineId = GeneratedColumn<String>(
    'machine_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES machines (id)',
    ),
  );
  static const VerificationMeta _visitDateMeta = const VerificationMeta(
    'visitDate',
  );
  @override
  late final GeneratedColumn<String> visitDate = GeneratedColumn<String>(
    'visit_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arrivalTimeMeta = const VerificationMeta(
    'arrivalTime',
  );
  @override
  late final GeneratedColumn<String> arrivalTime = GeneratedColumn<String>(
    'arrival_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departureTimeMeta = const VerificationMeta(
    'departureTime',
  );
  @override
  late final GeneratedColumn<String> departureTime = GeneratedColumn<String>(
    'departure_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serviceTypeMeta = const VerificationMeta(
    'serviceType',
  );
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
    'service_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('routine_maintenance'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('in_progress'),
  );
  static const VerificationMeta _technicianNameMeta = const VerificationMeta(
    'technicianName',
  );
  @override
  late final GeneratedColumn<String> technicianName = GeneratedColumn<String>(
    'technician_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reportedProblemMeta = const VerificationMeta(
    'reportedProblem',
  );
  @override
  late final GeneratedColumn<String> reportedProblem = GeneratedColumn<String>(
    'reported_problem',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diagnosisMeta = const VerificationMeta(
    'diagnosis',
  );
  @override
  late final GeneratedColumn<String> diagnosis = GeneratedColumn<String>(
    'diagnosis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rootCauseMeta = const VerificationMeta(
    'rootCause',
  );
  @override
  late final GeneratedColumn<String> rootCause = GeneratedColumn<String>(
    'root_cause',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workDoneMeta = const VerificationMeta(
    'workDone',
  );
  @override
  late final GeneratedColumn<String> workDone = GeneratedColumn<String>(
    'work_done',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionsTakenMeta = const VerificationMeta(
    'actionsTaken',
  );
  @override
  late final GeneratedColumn<String> actionsTaken = GeneratedColumn<String>(
    'actions_taken',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _testsPerformedMeta = const VerificationMeta(
    'testsPerformed',
  );
  @override
  late final GeneratedColumn<String> testsPerformed = GeneratedColumn<String>(
    'tests_performed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _machineStatusAfterMeta =
      const VerificationMeta('machineStatusAfter');
  @override
  late final GeneratedColumn<String> machineStatusAfter =
      GeneratedColumn<String>(
        'machine_status_after',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _recommendationsMeta = const VerificationMeta(
    'recommendations',
  );
  @override
  late final GeneratedColumn<String> recommendations = GeneratedColumn<String>(
    'recommendations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labourPaiseMeta = const VerificationMeta(
    'labourPaise',
  );
  @override
  late final GeneratedColumn<int> labourPaise = GeneratedColumn<int>(
    'labour_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _travelPaiseMeta = const VerificationMeta(
    'travelPaise',
  );
  @override
  late final GeneratedColumn<int> travelPaise = GeneratedColumn<int>(
    'travel_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _discountPaiseMeta = const VerificationMeta(
    'discountPaise',
  );
  @override
  late final GeneratedColumn<int> discountPaise = GeneratedColumn<int>(
    'discount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxRateBpMeta = const VerificationMeta(
    'taxRateBp',
  );
  @override
  late final GeneratedColumn<int> taxRateBp = GeneratedColumn<int>(
    'tax_rate_bp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _partsTotalPaiseMeta = const VerificationMeta(
    'partsTotalPaise',
  );
  @override
  late final GeneratedColumn<int> partsTotalPaise = GeneratedColumn<int>(
    'parts_total_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalPaiseMeta = const VerificationMeta(
    'totalPaise',
  );
  @override
  late final GeneratedColumn<int> totalPaise = GeneratedColumn<int>(
    'total_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _onsitePaymentPaiseMeta =
      const VerificationMeta('onsitePaymentPaise');
  @override
  late final GeneratedColumn<int> onsitePaymentPaise = GeneratedColumn<int>(
    'onsite_payment_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _onsitePaymentMethodMeta =
      const VerificationMeta('onsitePaymentMethod');
  @override
  late final GeneratedColumn<String> onsitePaymentMethod =
      GeneratedColumn<String>(
        'onsite_payment_method',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customerFeedbackMeta = const VerificationMeta(
    'customerFeedback',
  );
  @override
  late final GeneratedColumn<String> customerFeedback = GeneratedColumn<String>(
    'customer_feedback',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signedByMeta = const VerificationMeta(
    'signedBy',
  );
  @override
  late final GeneratedColumn<String> signedBy = GeneratedColumn<String>(
    'signed_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextServiceDateMeta = const VerificationMeta(
    'nextServiceDate',
  );
  @override
  late final GeneratedColumn<String> nextServiceDate = GeneratedColumn<String>(
    'next_service_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _internalNotesMeta = const VerificationMeta(
    'internalNotes',
  );
  @override
  late final GeneratedColumn<String> internalNotes = GeneratedColumn<String>(
    'internal_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    visitNo,
    companyId,
    machineId,
    visitDate,
    arrivalTime,
    departureTime,
    serviceType,
    status,
    technicianName,
    reportedProblem,
    symptoms,
    diagnosis,
    rootCause,
    workDone,
    actionsTaken,
    testsPerformed,
    machineStatusAfter,
    recommendations,
    labourPaise,
    travelPaise,
    discountPaise,
    taxRateBp,
    partsTotalPaise,
    totalPaise,
    onsitePaymentPaise,
    onsitePaymentMethod,
    customerFeedback,
    signedBy,
    nextServiceDate,
    internalNotes,
    completedAt,
    invoiceId,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_visits';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceVisit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('visit_no')) {
      context.handle(
        _visitNoMeta,
        visitNo.isAcceptableOrUnknown(data['visit_no']!, _visitNoMeta),
      );
    } else if (isInserting) {
      context.missing(_visitNoMeta);
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('machine_id')) {
      context.handle(
        _machineIdMeta,
        machineId.isAcceptableOrUnknown(data['machine_id']!, _machineIdMeta),
      );
    }
    if (data.containsKey('visit_date')) {
      context.handle(
        _visitDateMeta,
        visitDate.isAcceptableOrUnknown(data['visit_date']!, _visitDateMeta),
      );
    } else if (isInserting) {
      context.missing(_visitDateMeta);
    }
    if (data.containsKey('arrival_time')) {
      context.handle(
        _arrivalTimeMeta,
        arrivalTime.isAcceptableOrUnknown(
          data['arrival_time']!,
          _arrivalTimeMeta,
        ),
      );
    }
    if (data.containsKey('departure_time')) {
      context.handle(
        _departureTimeMeta,
        departureTime.isAcceptableOrUnknown(
          data['departure_time']!,
          _departureTimeMeta,
        ),
      );
    }
    if (data.containsKey('service_type')) {
      context.handle(
        _serviceTypeMeta,
        serviceType.isAcceptableOrUnknown(
          data['service_type']!,
          _serviceTypeMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('technician_name')) {
      context.handle(
        _technicianNameMeta,
        technicianName.isAcceptableOrUnknown(
          data['technician_name']!,
          _technicianNameMeta,
        ),
      );
    }
    if (data.containsKey('reported_problem')) {
      context.handle(
        _reportedProblemMeta,
        reportedProblem.isAcceptableOrUnknown(
          data['reported_problem']!,
          _reportedProblemMeta,
        ),
      );
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    }
    if (data.containsKey('diagnosis')) {
      context.handle(
        _diagnosisMeta,
        diagnosis.isAcceptableOrUnknown(data['diagnosis']!, _diagnosisMeta),
      );
    }
    if (data.containsKey('root_cause')) {
      context.handle(
        _rootCauseMeta,
        rootCause.isAcceptableOrUnknown(data['root_cause']!, _rootCauseMeta),
      );
    }
    if (data.containsKey('work_done')) {
      context.handle(
        _workDoneMeta,
        workDone.isAcceptableOrUnknown(data['work_done']!, _workDoneMeta),
      );
    }
    if (data.containsKey('actions_taken')) {
      context.handle(
        _actionsTakenMeta,
        actionsTaken.isAcceptableOrUnknown(
          data['actions_taken']!,
          _actionsTakenMeta,
        ),
      );
    }
    if (data.containsKey('tests_performed')) {
      context.handle(
        _testsPerformedMeta,
        testsPerformed.isAcceptableOrUnknown(
          data['tests_performed']!,
          _testsPerformedMeta,
        ),
      );
    }
    if (data.containsKey('machine_status_after')) {
      context.handle(
        _machineStatusAfterMeta,
        machineStatusAfter.isAcceptableOrUnknown(
          data['machine_status_after']!,
          _machineStatusAfterMeta,
        ),
      );
    }
    if (data.containsKey('recommendations')) {
      context.handle(
        _recommendationsMeta,
        recommendations.isAcceptableOrUnknown(
          data['recommendations']!,
          _recommendationsMeta,
        ),
      );
    }
    if (data.containsKey('labour_paise')) {
      context.handle(
        _labourPaiseMeta,
        labourPaise.isAcceptableOrUnknown(
          data['labour_paise']!,
          _labourPaiseMeta,
        ),
      );
    }
    if (data.containsKey('travel_paise')) {
      context.handle(
        _travelPaiseMeta,
        travelPaise.isAcceptableOrUnknown(
          data['travel_paise']!,
          _travelPaiseMeta,
        ),
      );
    }
    if (data.containsKey('discount_paise')) {
      context.handle(
        _discountPaiseMeta,
        discountPaise.isAcceptableOrUnknown(
          data['discount_paise']!,
          _discountPaiseMeta,
        ),
      );
    }
    if (data.containsKey('tax_rate_bp')) {
      context.handle(
        _taxRateBpMeta,
        taxRateBp.isAcceptableOrUnknown(data['tax_rate_bp']!, _taxRateBpMeta),
      );
    }
    if (data.containsKey('parts_total_paise')) {
      context.handle(
        _partsTotalPaiseMeta,
        partsTotalPaise.isAcceptableOrUnknown(
          data['parts_total_paise']!,
          _partsTotalPaiseMeta,
        ),
      );
    }
    if (data.containsKey('total_paise')) {
      context.handle(
        _totalPaiseMeta,
        totalPaise.isAcceptableOrUnknown(data['total_paise']!, _totalPaiseMeta),
      );
    }
    if (data.containsKey('onsite_payment_paise')) {
      context.handle(
        _onsitePaymentPaiseMeta,
        onsitePaymentPaise.isAcceptableOrUnknown(
          data['onsite_payment_paise']!,
          _onsitePaymentPaiseMeta,
        ),
      );
    }
    if (data.containsKey('onsite_payment_method')) {
      context.handle(
        _onsitePaymentMethodMeta,
        onsitePaymentMethod.isAcceptableOrUnknown(
          data['onsite_payment_method']!,
          _onsitePaymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('customer_feedback')) {
      context.handle(
        _customerFeedbackMeta,
        customerFeedback.isAcceptableOrUnknown(
          data['customer_feedback']!,
          _customerFeedbackMeta,
        ),
      );
    }
    if (data.containsKey('signed_by')) {
      context.handle(
        _signedByMeta,
        signedBy.isAcceptableOrUnknown(data['signed_by']!, _signedByMeta),
      );
    }
    if (data.containsKey('next_service_date')) {
      context.handle(
        _nextServiceDateMeta,
        nextServiceDate.isAcceptableOrUnknown(
          data['next_service_date']!,
          _nextServiceDateMeta,
        ),
      );
    }
    if (data.containsKey('internal_notes')) {
      context.handle(
        _internalNotesMeta,
        internalNotes.isAcceptableOrUnknown(
          data['internal_notes']!,
          _internalNotesMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceVisit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceVisit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      visitNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_no'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      )!,
      machineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_id'],
      ),
      visitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_date'],
      )!,
      arrivalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arrival_time'],
      ),
      departureTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departure_time'],
      ),
      serviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      technicianName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technician_name'],
      ),
      reportedProblem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reported_problem'],
      ),
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      ),
      diagnosis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosis'],
      ),
      rootCause: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_cause'],
      ),
      workDone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_done'],
      ),
      actionsTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actions_taken'],
      ),
      testsPerformed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tests_performed'],
      ),
      machineStatusAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_status_after'],
      ),
      recommendations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommendations'],
      ),
      labourPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}labour_paise'],
      )!,
      travelPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}travel_paise'],
      )!,
      discountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_paise'],
      )!,
      taxRateBp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_rate_bp'],
      )!,
      partsTotalPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parts_total_paise'],
      )!,
      totalPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_paise'],
      )!,
      onsitePaymentPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}onsite_payment_paise'],
      )!,
      onsitePaymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}onsite_payment_method'],
      ),
      customerFeedback: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_feedback'],
      ),
      signedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signed_by'],
      ),
      nextServiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_service_date'],
      ),
      internalNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}internal_notes'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $ServiceVisitsTable createAlias(String alias) {
    return $ServiceVisitsTable(attachedDatabase, alias);
  }
}

class ServiceVisit extends DataClass implements Insertable<ServiceVisit> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String visitNo;
  final String companyId;
  final String? machineId;
  final String visitDate;
  final String? arrivalTime;
  final String? departureTime;
  final String serviceType;
  final String status;
  final String? technicianName;
  final String? reportedProblem;
  final String? symptoms;
  final String? diagnosis;
  final String? rootCause;
  final String? workDone;
  final String? actionsTaken;
  final String? testsPerformed;
  final String? machineStatusAfter;
  final String? recommendations;
  final int labourPaise;
  final int travelPaise;
  final int discountPaise;
  final int taxRateBp;
  final int partsTotalPaise;
  final int totalPaise;
  final int onsitePaymentPaise;
  final String? onsitePaymentMethod;
  final String? customerFeedback;
  final String? signedBy;
  final String? nextServiceDate;
  final String? internalNotes;
  final DateTime? completedAt;
  final String? invoiceId;
  final DateTime? archivedAt;
  const ServiceVisit({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.visitNo,
    required this.companyId,
    this.machineId,
    required this.visitDate,
    this.arrivalTime,
    this.departureTime,
    required this.serviceType,
    required this.status,
    this.technicianName,
    this.reportedProblem,
    this.symptoms,
    this.diagnosis,
    this.rootCause,
    this.workDone,
    this.actionsTaken,
    this.testsPerformed,
    this.machineStatusAfter,
    this.recommendations,
    required this.labourPaise,
    required this.travelPaise,
    required this.discountPaise,
    required this.taxRateBp,
    required this.partsTotalPaise,
    required this.totalPaise,
    required this.onsitePaymentPaise,
    this.onsitePaymentMethod,
    this.customerFeedback,
    this.signedBy,
    this.nextServiceDate,
    this.internalNotes,
    this.completedAt,
    this.invoiceId,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['visit_no'] = Variable<String>(visitNo);
    map['company_id'] = Variable<String>(companyId);
    if (!nullToAbsent || machineId != null) {
      map['machine_id'] = Variable<String>(machineId);
    }
    map['visit_date'] = Variable<String>(visitDate);
    if (!nullToAbsent || arrivalTime != null) {
      map['arrival_time'] = Variable<String>(arrivalTime);
    }
    if (!nullToAbsent || departureTime != null) {
      map['departure_time'] = Variable<String>(departureTime);
    }
    map['service_type'] = Variable<String>(serviceType);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || technicianName != null) {
      map['technician_name'] = Variable<String>(technicianName);
    }
    if (!nullToAbsent || reportedProblem != null) {
      map['reported_problem'] = Variable<String>(reportedProblem);
    }
    if (!nullToAbsent || symptoms != null) {
      map['symptoms'] = Variable<String>(symptoms);
    }
    if (!nullToAbsent || diagnosis != null) {
      map['diagnosis'] = Variable<String>(diagnosis);
    }
    if (!nullToAbsent || rootCause != null) {
      map['root_cause'] = Variable<String>(rootCause);
    }
    if (!nullToAbsent || workDone != null) {
      map['work_done'] = Variable<String>(workDone);
    }
    if (!nullToAbsent || actionsTaken != null) {
      map['actions_taken'] = Variable<String>(actionsTaken);
    }
    if (!nullToAbsent || testsPerformed != null) {
      map['tests_performed'] = Variable<String>(testsPerformed);
    }
    if (!nullToAbsent || machineStatusAfter != null) {
      map['machine_status_after'] = Variable<String>(machineStatusAfter);
    }
    if (!nullToAbsent || recommendations != null) {
      map['recommendations'] = Variable<String>(recommendations);
    }
    map['labour_paise'] = Variable<int>(labourPaise);
    map['travel_paise'] = Variable<int>(travelPaise);
    map['discount_paise'] = Variable<int>(discountPaise);
    map['tax_rate_bp'] = Variable<int>(taxRateBp);
    map['parts_total_paise'] = Variable<int>(partsTotalPaise);
    map['total_paise'] = Variable<int>(totalPaise);
    map['onsite_payment_paise'] = Variable<int>(onsitePaymentPaise);
    if (!nullToAbsent || onsitePaymentMethod != null) {
      map['onsite_payment_method'] = Variable<String>(onsitePaymentMethod);
    }
    if (!nullToAbsent || customerFeedback != null) {
      map['customer_feedback'] = Variable<String>(customerFeedback);
    }
    if (!nullToAbsent || signedBy != null) {
      map['signed_by'] = Variable<String>(signedBy);
    }
    if (!nullToAbsent || nextServiceDate != null) {
      map['next_service_date'] = Variable<String>(nextServiceDate);
    }
    if (!nullToAbsent || internalNotes != null) {
      map['internal_notes'] = Variable<String>(internalNotes);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || invoiceId != null) {
      map['invoice_id'] = Variable<String>(invoiceId);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  ServiceVisitsCompanion toCompanion(bool nullToAbsent) {
    return ServiceVisitsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      visitNo: Value(visitNo),
      companyId: Value(companyId),
      machineId: machineId == null && nullToAbsent
          ? const Value.absent()
          : Value(machineId),
      visitDate: Value(visitDate),
      arrivalTime: arrivalTime == null && nullToAbsent
          ? const Value.absent()
          : Value(arrivalTime),
      departureTime: departureTime == null && nullToAbsent
          ? const Value.absent()
          : Value(departureTime),
      serviceType: Value(serviceType),
      status: Value(status),
      technicianName: technicianName == null && nullToAbsent
          ? const Value.absent()
          : Value(technicianName),
      reportedProblem: reportedProblem == null && nullToAbsent
          ? const Value.absent()
          : Value(reportedProblem),
      symptoms: symptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(symptoms),
      diagnosis: diagnosis == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosis),
      rootCause: rootCause == null && nullToAbsent
          ? const Value.absent()
          : Value(rootCause),
      workDone: workDone == null && nullToAbsent
          ? const Value.absent()
          : Value(workDone),
      actionsTaken: actionsTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(actionsTaken),
      testsPerformed: testsPerformed == null && nullToAbsent
          ? const Value.absent()
          : Value(testsPerformed),
      machineStatusAfter: machineStatusAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(machineStatusAfter),
      recommendations: recommendations == null && nullToAbsent
          ? const Value.absent()
          : Value(recommendations),
      labourPaise: Value(labourPaise),
      travelPaise: Value(travelPaise),
      discountPaise: Value(discountPaise),
      taxRateBp: Value(taxRateBp),
      partsTotalPaise: Value(partsTotalPaise),
      totalPaise: Value(totalPaise),
      onsitePaymentPaise: Value(onsitePaymentPaise),
      onsitePaymentMethod: onsitePaymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(onsitePaymentMethod),
      customerFeedback: customerFeedback == null && nullToAbsent
          ? const Value.absent()
          : Value(customerFeedback),
      signedBy: signedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(signedBy),
      nextServiceDate: nextServiceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextServiceDate),
      internalNotes: internalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(internalNotes),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      invoiceId: invoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceId),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory ServiceVisit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceVisit(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      visitNo: serializer.fromJson<String>(json['visitNo']),
      companyId: serializer.fromJson<String>(json['companyId']),
      machineId: serializer.fromJson<String?>(json['machineId']),
      visitDate: serializer.fromJson<String>(json['visitDate']),
      arrivalTime: serializer.fromJson<String?>(json['arrivalTime']),
      departureTime: serializer.fromJson<String?>(json['departureTime']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      status: serializer.fromJson<String>(json['status']),
      technicianName: serializer.fromJson<String?>(json['technicianName']),
      reportedProblem: serializer.fromJson<String?>(json['reportedProblem']),
      symptoms: serializer.fromJson<String?>(json['symptoms']),
      diagnosis: serializer.fromJson<String?>(json['diagnosis']),
      rootCause: serializer.fromJson<String?>(json['rootCause']),
      workDone: serializer.fromJson<String?>(json['workDone']),
      actionsTaken: serializer.fromJson<String?>(json['actionsTaken']),
      testsPerformed: serializer.fromJson<String?>(json['testsPerformed']),
      machineStatusAfter: serializer.fromJson<String?>(
        json['machineStatusAfter'],
      ),
      recommendations: serializer.fromJson<String?>(json['recommendations']),
      labourPaise: serializer.fromJson<int>(json['labourPaise']),
      travelPaise: serializer.fromJson<int>(json['travelPaise']),
      discountPaise: serializer.fromJson<int>(json['discountPaise']),
      taxRateBp: serializer.fromJson<int>(json['taxRateBp']),
      partsTotalPaise: serializer.fromJson<int>(json['partsTotalPaise']),
      totalPaise: serializer.fromJson<int>(json['totalPaise']),
      onsitePaymentPaise: serializer.fromJson<int>(json['onsitePaymentPaise']),
      onsitePaymentMethod: serializer.fromJson<String?>(
        json['onsitePaymentMethod'],
      ),
      customerFeedback: serializer.fromJson<String?>(json['customerFeedback']),
      signedBy: serializer.fromJson<String?>(json['signedBy']),
      nextServiceDate: serializer.fromJson<String?>(json['nextServiceDate']),
      internalNotes: serializer.fromJson<String?>(json['internalNotes']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      invoiceId: serializer.fromJson<String?>(json['invoiceId']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'visitNo': serializer.toJson<String>(visitNo),
      'companyId': serializer.toJson<String>(companyId),
      'machineId': serializer.toJson<String?>(machineId),
      'visitDate': serializer.toJson<String>(visitDate),
      'arrivalTime': serializer.toJson<String?>(arrivalTime),
      'departureTime': serializer.toJson<String?>(departureTime),
      'serviceType': serializer.toJson<String>(serviceType),
      'status': serializer.toJson<String>(status),
      'technicianName': serializer.toJson<String?>(technicianName),
      'reportedProblem': serializer.toJson<String?>(reportedProblem),
      'symptoms': serializer.toJson<String?>(symptoms),
      'diagnosis': serializer.toJson<String?>(diagnosis),
      'rootCause': serializer.toJson<String?>(rootCause),
      'workDone': serializer.toJson<String?>(workDone),
      'actionsTaken': serializer.toJson<String?>(actionsTaken),
      'testsPerformed': serializer.toJson<String?>(testsPerformed),
      'machineStatusAfter': serializer.toJson<String?>(machineStatusAfter),
      'recommendations': serializer.toJson<String?>(recommendations),
      'labourPaise': serializer.toJson<int>(labourPaise),
      'travelPaise': serializer.toJson<int>(travelPaise),
      'discountPaise': serializer.toJson<int>(discountPaise),
      'taxRateBp': serializer.toJson<int>(taxRateBp),
      'partsTotalPaise': serializer.toJson<int>(partsTotalPaise),
      'totalPaise': serializer.toJson<int>(totalPaise),
      'onsitePaymentPaise': serializer.toJson<int>(onsitePaymentPaise),
      'onsitePaymentMethod': serializer.toJson<String?>(onsitePaymentMethod),
      'customerFeedback': serializer.toJson<String?>(customerFeedback),
      'signedBy': serializer.toJson<String?>(signedBy),
      'nextServiceDate': serializer.toJson<String?>(nextServiceDate),
      'internalNotes': serializer.toJson<String?>(internalNotes),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'invoiceId': serializer.toJson<String?>(invoiceId),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  ServiceVisit copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? visitNo,
    String? companyId,
    Value<String?> machineId = const Value.absent(),
    String? visitDate,
    Value<String?> arrivalTime = const Value.absent(),
    Value<String?> departureTime = const Value.absent(),
    String? serviceType,
    String? status,
    Value<String?> technicianName = const Value.absent(),
    Value<String?> reportedProblem = const Value.absent(),
    Value<String?> symptoms = const Value.absent(),
    Value<String?> diagnosis = const Value.absent(),
    Value<String?> rootCause = const Value.absent(),
    Value<String?> workDone = const Value.absent(),
    Value<String?> actionsTaken = const Value.absent(),
    Value<String?> testsPerformed = const Value.absent(),
    Value<String?> machineStatusAfter = const Value.absent(),
    Value<String?> recommendations = const Value.absent(),
    int? labourPaise,
    int? travelPaise,
    int? discountPaise,
    int? taxRateBp,
    int? partsTotalPaise,
    int? totalPaise,
    int? onsitePaymentPaise,
    Value<String?> onsitePaymentMethod = const Value.absent(),
    Value<String?> customerFeedback = const Value.absent(),
    Value<String?> signedBy = const Value.absent(),
    Value<String?> nextServiceDate = const Value.absent(),
    Value<String?> internalNotes = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> invoiceId = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => ServiceVisit(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    visitNo: visitNo ?? this.visitNo,
    companyId: companyId ?? this.companyId,
    machineId: machineId.present ? machineId.value : this.machineId,
    visitDate: visitDate ?? this.visitDate,
    arrivalTime: arrivalTime.present ? arrivalTime.value : this.arrivalTime,
    departureTime: departureTime.present
        ? departureTime.value
        : this.departureTime,
    serviceType: serviceType ?? this.serviceType,
    status: status ?? this.status,
    technicianName: technicianName.present
        ? technicianName.value
        : this.technicianName,
    reportedProblem: reportedProblem.present
        ? reportedProblem.value
        : this.reportedProblem,
    symptoms: symptoms.present ? symptoms.value : this.symptoms,
    diagnosis: diagnosis.present ? diagnosis.value : this.diagnosis,
    rootCause: rootCause.present ? rootCause.value : this.rootCause,
    workDone: workDone.present ? workDone.value : this.workDone,
    actionsTaken: actionsTaken.present ? actionsTaken.value : this.actionsTaken,
    testsPerformed: testsPerformed.present
        ? testsPerformed.value
        : this.testsPerformed,
    machineStatusAfter: machineStatusAfter.present
        ? machineStatusAfter.value
        : this.machineStatusAfter,
    recommendations: recommendations.present
        ? recommendations.value
        : this.recommendations,
    labourPaise: labourPaise ?? this.labourPaise,
    travelPaise: travelPaise ?? this.travelPaise,
    discountPaise: discountPaise ?? this.discountPaise,
    taxRateBp: taxRateBp ?? this.taxRateBp,
    partsTotalPaise: partsTotalPaise ?? this.partsTotalPaise,
    totalPaise: totalPaise ?? this.totalPaise,
    onsitePaymentPaise: onsitePaymentPaise ?? this.onsitePaymentPaise,
    onsitePaymentMethod: onsitePaymentMethod.present
        ? onsitePaymentMethod.value
        : this.onsitePaymentMethod,
    customerFeedback: customerFeedback.present
        ? customerFeedback.value
        : this.customerFeedback,
    signedBy: signedBy.present ? signedBy.value : this.signedBy,
    nextServiceDate: nextServiceDate.present
        ? nextServiceDate.value
        : this.nextServiceDate,
    internalNotes: internalNotes.present
        ? internalNotes.value
        : this.internalNotes,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  ServiceVisit copyWithCompanion(ServiceVisitsCompanion data) {
    return ServiceVisit(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      visitNo: data.visitNo.present ? data.visitNo.value : this.visitNo,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      machineId: data.machineId.present ? data.machineId.value : this.machineId,
      visitDate: data.visitDate.present ? data.visitDate.value : this.visitDate,
      arrivalTime: data.arrivalTime.present
          ? data.arrivalTime.value
          : this.arrivalTime,
      departureTime: data.departureTime.present
          ? data.departureTime.value
          : this.departureTime,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      status: data.status.present ? data.status.value : this.status,
      technicianName: data.technicianName.present
          ? data.technicianName.value
          : this.technicianName,
      reportedProblem: data.reportedProblem.present
          ? data.reportedProblem.value
          : this.reportedProblem,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      diagnosis: data.diagnosis.present ? data.diagnosis.value : this.diagnosis,
      rootCause: data.rootCause.present ? data.rootCause.value : this.rootCause,
      workDone: data.workDone.present ? data.workDone.value : this.workDone,
      actionsTaken: data.actionsTaken.present
          ? data.actionsTaken.value
          : this.actionsTaken,
      testsPerformed: data.testsPerformed.present
          ? data.testsPerformed.value
          : this.testsPerformed,
      machineStatusAfter: data.machineStatusAfter.present
          ? data.machineStatusAfter.value
          : this.machineStatusAfter,
      recommendations: data.recommendations.present
          ? data.recommendations.value
          : this.recommendations,
      labourPaise: data.labourPaise.present
          ? data.labourPaise.value
          : this.labourPaise,
      travelPaise: data.travelPaise.present
          ? data.travelPaise.value
          : this.travelPaise,
      discountPaise: data.discountPaise.present
          ? data.discountPaise.value
          : this.discountPaise,
      taxRateBp: data.taxRateBp.present ? data.taxRateBp.value : this.taxRateBp,
      partsTotalPaise: data.partsTotalPaise.present
          ? data.partsTotalPaise.value
          : this.partsTotalPaise,
      totalPaise: data.totalPaise.present
          ? data.totalPaise.value
          : this.totalPaise,
      onsitePaymentPaise: data.onsitePaymentPaise.present
          ? data.onsitePaymentPaise.value
          : this.onsitePaymentPaise,
      onsitePaymentMethod: data.onsitePaymentMethod.present
          ? data.onsitePaymentMethod.value
          : this.onsitePaymentMethod,
      customerFeedback: data.customerFeedback.present
          ? data.customerFeedback.value
          : this.customerFeedback,
      signedBy: data.signedBy.present ? data.signedBy.value : this.signedBy,
      nextServiceDate: data.nextServiceDate.present
          ? data.nextServiceDate.value
          : this.nextServiceDate,
      internalNotes: data.internalNotes.present
          ? data.internalNotes.value
          : this.internalNotes,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceVisit(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('visitNo: $visitNo, ')
          ..write('companyId: $companyId, ')
          ..write('machineId: $machineId, ')
          ..write('visitDate: $visitDate, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('departureTime: $departureTime, ')
          ..write('serviceType: $serviceType, ')
          ..write('status: $status, ')
          ..write('technicianName: $technicianName, ')
          ..write('reportedProblem: $reportedProblem, ')
          ..write('symptoms: $symptoms, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('rootCause: $rootCause, ')
          ..write('workDone: $workDone, ')
          ..write('actionsTaken: $actionsTaken, ')
          ..write('testsPerformed: $testsPerformed, ')
          ..write('machineStatusAfter: $machineStatusAfter, ')
          ..write('recommendations: $recommendations, ')
          ..write('labourPaise: $labourPaise, ')
          ..write('travelPaise: $travelPaise, ')
          ..write('discountPaise: $discountPaise, ')
          ..write('taxRateBp: $taxRateBp, ')
          ..write('partsTotalPaise: $partsTotalPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('onsitePaymentPaise: $onsitePaymentPaise, ')
          ..write('onsitePaymentMethod: $onsitePaymentMethod, ')
          ..write('customerFeedback: $customerFeedback, ')
          ..write('signedBy: $signedBy, ')
          ..write('nextServiceDate: $nextServiceDate, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('completedAt: $completedAt, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    serverRev,
    visitNo,
    companyId,
    machineId,
    visitDate,
    arrivalTime,
    departureTime,
    serviceType,
    status,
    technicianName,
    reportedProblem,
    symptoms,
    diagnosis,
    rootCause,
    workDone,
    actionsTaken,
    testsPerformed,
    machineStatusAfter,
    recommendations,
    labourPaise,
    travelPaise,
    discountPaise,
    taxRateBp,
    partsTotalPaise,
    totalPaise,
    onsitePaymentPaise,
    onsitePaymentMethod,
    customerFeedback,
    signedBy,
    nextServiceDate,
    internalNotes,
    completedAt,
    invoiceId,
    archivedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceVisit &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.visitNo == this.visitNo &&
          other.companyId == this.companyId &&
          other.machineId == this.machineId &&
          other.visitDate == this.visitDate &&
          other.arrivalTime == this.arrivalTime &&
          other.departureTime == this.departureTime &&
          other.serviceType == this.serviceType &&
          other.status == this.status &&
          other.technicianName == this.technicianName &&
          other.reportedProblem == this.reportedProblem &&
          other.symptoms == this.symptoms &&
          other.diagnosis == this.diagnosis &&
          other.rootCause == this.rootCause &&
          other.workDone == this.workDone &&
          other.actionsTaken == this.actionsTaken &&
          other.testsPerformed == this.testsPerformed &&
          other.machineStatusAfter == this.machineStatusAfter &&
          other.recommendations == this.recommendations &&
          other.labourPaise == this.labourPaise &&
          other.travelPaise == this.travelPaise &&
          other.discountPaise == this.discountPaise &&
          other.taxRateBp == this.taxRateBp &&
          other.partsTotalPaise == this.partsTotalPaise &&
          other.totalPaise == this.totalPaise &&
          other.onsitePaymentPaise == this.onsitePaymentPaise &&
          other.onsitePaymentMethod == this.onsitePaymentMethod &&
          other.customerFeedback == this.customerFeedback &&
          other.signedBy == this.signedBy &&
          other.nextServiceDate == this.nextServiceDate &&
          other.internalNotes == this.internalNotes &&
          other.completedAt == this.completedAt &&
          other.invoiceId == this.invoiceId &&
          other.archivedAt == this.archivedAt);
}

class ServiceVisitsCompanion extends UpdateCompanion<ServiceVisit> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> visitNo;
  final Value<String> companyId;
  final Value<String?> machineId;
  final Value<String> visitDate;
  final Value<String?> arrivalTime;
  final Value<String?> departureTime;
  final Value<String> serviceType;
  final Value<String> status;
  final Value<String?> technicianName;
  final Value<String?> reportedProblem;
  final Value<String?> symptoms;
  final Value<String?> diagnosis;
  final Value<String?> rootCause;
  final Value<String?> workDone;
  final Value<String?> actionsTaken;
  final Value<String?> testsPerformed;
  final Value<String?> machineStatusAfter;
  final Value<String?> recommendations;
  final Value<int> labourPaise;
  final Value<int> travelPaise;
  final Value<int> discountPaise;
  final Value<int> taxRateBp;
  final Value<int> partsTotalPaise;
  final Value<int> totalPaise;
  final Value<int> onsitePaymentPaise;
  final Value<String?> onsitePaymentMethod;
  final Value<String?> customerFeedback;
  final Value<String?> signedBy;
  final Value<String?> nextServiceDate;
  final Value<String?> internalNotes;
  final Value<DateTime?> completedAt;
  final Value<String?> invoiceId;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const ServiceVisitsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.visitNo = const Value.absent(),
    this.companyId = const Value.absent(),
    this.machineId = const Value.absent(),
    this.visitDate = const Value.absent(),
    this.arrivalTime = const Value.absent(),
    this.departureTime = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.status = const Value.absent(),
    this.technicianName = const Value.absent(),
    this.reportedProblem = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.rootCause = const Value.absent(),
    this.workDone = const Value.absent(),
    this.actionsTaken = const Value.absent(),
    this.testsPerformed = const Value.absent(),
    this.machineStatusAfter = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.labourPaise = const Value.absent(),
    this.travelPaise = const Value.absent(),
    this.discountPaise = const Value.absent(),
    this.taxRateBp = const Value.absent(),
    this.partsTotalPaise = const Value.absent(),
    this.totalPaise = const Value.absent(),
    this.onsitePaymentPaise = const Value.absent(),
    this.onsitePaymentMethod = const Value.absent(),
    this.customerFeedback = const Value.absent(),
    this.signedBy = const Value.absent(),
    this.nextServiceDate = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceVisitsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String visitNo,
    required String companyId,
    this.machineId = const Value.absent(),
    required String visitDate,
    this.arrivalTime = const Value.absent(),
    this.departureTime = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.status = const Value.absent(),
    this.technicianName = const Value.absent(),
    this.reportedProblem = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.rootCause = const Value.absent(),
    this.workDone = const Value.absent(),
    this.actionsTaken = const Value.absent(),
    this.testsPerformed = const Value.absent(),
    this.machineStatusAfter = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.labourPaise = const Value.absent(),
    this.travelPaise = const Value.absent(),
    this.discountPaise = const Value.absent(),
    this.taxRateBp = const Value.absent(),
    this.partsTotalPaise = const Value.absent(),
    this.totalPaise = const Value.absent(),
    this.onsitePaymentPaise = const Value.absent(),
    this.onsitePaymentMethod = const Value.absent(),
    this.customerFeedback = const Value.absent(),
    this.signedBy = const Value.absent(),
    this.nextServiceDate = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       visitNo = Value(visitNo),
       companyId = Value(companyId),
       visitDate = Value(visitDate);
  static Insertable<ServiceVisit> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? visitNo,
    Expression<String>? companyId,
    Expression<String>? machineId,
    Expression<String>? visitDate,
    Expression<String>? arrivalTime,
    Expression<String>? departureTime,
    Expression<String>? serviceType,
    Expression<String>? status,
    Expression<String>? technicianName,
    Expression<String>? reportedProblem,
    Expression<String>? symptoms,
    Expression<String>? diagnosis,
    Expression<String>? rootCause,
    Expression<String>? workDone,
    Expression<String>? actionsTaken,
    Expression<String>? testsPerformed,
    Expression<String>? machineStatusAfter,
    Expression<String>? recommendations,
    Expression<int>? labourPaise,
    Expression<int>? travelPaise,
    Expression<int>? discountPaise,
    Expression<int>? taxRateBp,
    Expression<int>? partsTotalPaise,
    Expression<int>? totalPaise,
    Expression<int>? onsitePaymentPaise,
    Expression<String>? onsitePaymentMethod,
    Expression<String>? customerFeedback,
    Expression<String>? signedBy,
    Expression<String>? nextServiceDate,
    Expression<String>? internalNotes,
    Expression<DateTime>? completedAt,
    Expression<String>? invoiceId,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (visitNo != null) 'visit_no': visitNo,
      if (companyId != null) 'company_id': companyId,
      if (machineId != null) 'machine_id': machineId,
      if (visitDate != null) 'visit_date': visitDate,
      if (arrivalTime != null) 'arrival_time': arrivalTime,
      if (departureTime != null) 'departure_time': departureTime,
      if (serviceType != null) 'service_type': serviceType,
      if (status != null) 'status': status,
      if (technicianName != null) 'technician_name': technicianName,
      if (reportedProblem != null) 'reported_problem': reportedProblem,
      if (symptoms != null) 'symptoms': symptoms,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (rootCause != null) 'root_cause': rootCause,
      if (workDone != null) 'work_done': workDone,
      if (actionsTaken != null) 'actions_taken': actionsTaken,
      if (testsPerformed != null) 'tests_performed': testsPerformed,
      if (machineStatusAfter != null)
        'machine_status_after': machineStatusAfter,
      if (recommendations != null) 'recommendations': recommendations,
      if (labourPaise != null) 'labour_paise': labourPaise,
      if (travelPaise != null) 'travel_paise': travelPaise,
      if (discountPaise != null) 'discount_paise': discountPaise,
      if (taxRateBp != null) 'tax_rate_bp': taxRateBp,
      if (partsTotalPaise != null) 'parts_total_paise': partsTotalPaise,
      if (totalPaise != null) 'total_paise': totalPaise,
      if (onsitePaymentPaise != null)
        'onsite_payment_paise': onsitePaymentPaise,
      if (onsitePaymentMethod != null)
        'onsite_payment_method': onsitePaymentMethod,
      if (customerFeedback != null) 'customer_feedback': customerFeedback,
      if (signedBy != null) 'signed_by': signedBy,
      if (nextServiceDate != null) 'next_service_date': nextServiceDate,
      if (internalNotes != null) 'internal_notes': internalNotes,
      if (completedAt != null) 'completed_at': completedAt,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceVisitsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? visitNo,
    Value<String>? companyId,
    Value<String?>? machineId,
    Value<String>? visitDate,
    Value<String?>? arrivalTime,
    Value<String?>? departureTime,
    Value<String>? serviceType,
    Value<String>? status,
    Value<String?>? technicianName,
    Value<String?>? reportedProblem,
    Value<String?>? symptoms,
    Value<String?>? diagnosis,
    Value<String?>? rootCause,
    Value<String?>? workDone,
    Value<String?>? actionsTaken,
    Value<String?>? testsPerformed,
    Value<String?>? machineStatusAfter,
    Value<String?>? recommendations,
    Value<int>? labourPaise,
    Value<int>? travelPaise,
    Value<int>? discountPaise,
    Value<int>? taxRateBp,
    Value<int>? partsTotalPaise,
    Value<int>? totalPaise,
    Value<int>? onsitePaymentPaise,
    Value<String?>? onsitePaymentMethod,
    Value<String?>? customerFeedback,
    Value<String?>? signedBy,
    Value<String?>? nextServiceDate,
    Value<String?>? internalNotes,
    Value<DateTime?>? completedAt,
    Value<String?>? invoiceId,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return ServiceVisitsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      visitNo: visitNo ?? this.visitNo,
      companyId: companyId ?? this.companyId,
      machineId: machineId ?? this.machineId,
      visitDate: visitDate ?? this.visitDate,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      technicianName: technicianName ?? this.technicianName,
      reportedProblem: reportedProblem ?? this.reportedProblem,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      rootCause: rootCause ?? this.rootCause,
      workDone: workDone ?? this.workDone,
      actionsTaken: actionsTaken ?? this.actionsTaken,
      testsPerformed: testsPerformed ?? this.testsPerformed,
      machineStatusAfter: machineStatusAfter ?? this.machineStatusAfter,
      recommendations: recommendations ?? this.recommendations,
      labourPaise: labourPaise ?? this.labourPaise,
      travelPaise: travelPaise ?? this.travelPaise,
      discountPaise: discountPaise ?? this.discountPaise,
      taxRateBp: taxRateBp ?? this.taxRateBp,
      partsTotalPaise: partsTotalPaise ?? this.partsTotalPaise,
      totalPaise: totalPaise ?? this.totalPaise,
      onsitePaymentPaise: onsitePaymentPaise ?? this.onsitePaymentPaise,
      onsitePaymentMethod: onsitePaymentMethod ?? this.onsitePaymentMethod,
      customerFeedback: customerFeedback ?? this.customerFeedback,
      signedBy: signedBy ?? this.signedBy,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
      internalNotes: internalNotes ?? this.internalNotes,
      completedAt: completedAt ?? this.completedAt,
      invoiceId: invoiceId ?? this.invoiceId,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (visitNo.present) {
      map['visit_no'] = Variable<String>(visitNo.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (machineId.present) {
      map['machine_id'] = Variable<String>(machineId.value);
    }
    if (visitDate.present) {
      map['visit_date'] = Variable<String>(visitDate.value);
    }
    if (arrivalTime.present) {
      map['arrival_time'] = Variable<String>(arrivalTime.value);
    }
    if (departureTime.present) {
      map['departure_time'] = Variable<String>(departureTime.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (technicianName.present) {
      map['technician_name'] = Variable<String>(technicianName.value);
    }
    if (reportedProblem.present) {
      map['reported_problem'] = Variable<String>(reportedProblem.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (diagnosis.present) {
      map['diagnosis'] = Variable<String>(diagnosis.value);
    }
    if (rootCause.present) {
      map['root_cause'] = Variable<String>(rootCause.value);
    }
    if (workDone.present) {
      map['work_done'] = Variable<String>(workDone.value);
    }
    if (actionsTaken.present) {
      map['actions_taken'] = Variable<String>(actionsTaken.value);
    }
    if (testsPerformed.present) {
      map['tests_performed'] = Variable<String>(testsPerformed.value);
    }
    if (machineStatusAfter.present) {
      map['machine_status_after'] = Variable<String>(machineStatusAfter.value);
    }
    if (recommendations.present) {
      map['recommendations'] = Variable<String>(recommendations.value);
    }
    if (labourPaise.present) {
      map['labour_paise'] = Variable<int>(labourPaise.value);
    }
    if (travelPaise.present) {
      map['travel_paise'] = Variable<int>(travelPaise.value);
    }
    if (discountPaise.present) {
      map['discount_paise'] = Variable<int>(discountPaise.value);
    }
    if (taxRateBp.present) {
      map['tax_rate_bp'] = Variable<int>(taxRateBp.value);
    }
    if (partsTotalPaise.present) {
      map['parts_total_paise'] = Variable<int>(partsTotalPaise.value);
    }
    if (totalPaise.present) {
      map['total_paise'] = Variable<int>(totalPaise.value);
    }
    if (onsitePaymentPaise.present) {
      map['onsite_payment_paise'] = Variable<int>(onsitePaymentPaise.value);
    }
    if (onsitePaymentMethod.present) {
      map['onsite_payment_method'] = Variable<String>(
        onsitePaymentMethod.value,
      );
    }
    if (customerFeedback.present) {
      map['customer_feedback'] = Variable<String>(customerFeedback.value);
    }
    if (signedBy.present) {
      map['signed_by'] = Variable<String>(signedBy.value);
    }
    if (nextServiceDate.present) {
      map['next_service_date'] = Variable<String>(nextServiceDate.value);
    }
    if (internalNotes.present) {
      map['internal_notes'] = Variable<String>(internalNotes.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceVisitsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('visitNo: $visitNo, ')
          ..write('companyId: $companyId, ')
          ..write('machineId: $machineId, ')
          ..write('visitDate: $visitDate, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('departureTime: $departureTime, ')
          ..write('serviceType: $serviceType, ')
          ..write('status: $status, ')
          ..write('technicianName: $technicianName, ')
          ..write('reportedProblem: $reportedProblem, ')
          ..write('symptoms: $symptoms, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('rootCause: $rootCause, ')
          ..write('workDone: $workDone, ')
          ..write('actionsTaken: $actionsTaken, ')
          ..write('testsPerformed: $testsPerformed, ')
          ..write('machineStatusAfter: $machineStatusAfter, ')
          ..write('recommendations: $recommendations, ')
          ..write('labourPaise: $labourPaise, ')
          ..write('travelPaise: $travelPaise, ')
          ..write('discountPaise: $discountPaise, ')
          ..write('taxRateBp: $taxRateBp, ')
          ..write('partsTotalPaise: $partsTotalPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('onsitePaymentPaise: $onsitePaymentPaise, ')
          ..write('onsitePaymentMethod: $onsitePaymentMethod, ')
          ..write('customerFeedback: $customerFeedback, ')
          ..write('signedBy: $signedBy, ')
          ..write('nextServiceDate: $nextServiceDate, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('completedAt: $completedAt, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisitPartsTable extends VisitParts
    with TableInfo<$VisitPartsTable, VisitPart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitPartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_visits (id)',
    ),
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id)',
    ),
  );
  static const VerificationMeta _partNameMeta = const VerificationMeta(
    'partName',
  );
  @override
  late final GeneratedColumn<String> partName = GeneratedColumn<String>(
    'part_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partNumberMeta = const VerificationMeta(
    'partNumber',
  );
  @override
  late final GeneratedColumn<String> partNumber = GeneratedColumn<String>(
    'part_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qtyMilliMeta = const VerificationMeta(
    'qtyMilli',
  );
  @override
  late final GeneratedColumn<int> qtyMilli = GeneratedColumn<int>(
    'qty_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostPaiseMeta = const VerificationMeta(
    'unitCostPaise',
  );
  @override
  late final GeneratedColumn<int> unitCostPaise = GeneratedColumn<int>(
    'unit_cost_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPricePaiseMeta = const VerificationMeta(
    'unitPricePaise',
  );
  @override
  late final GeneratedColumn<int> unitPricePaise = GeneratedColumn<int>(
    'unit_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    visitId,
    partId,
    partName,
    partNumber,
    qtyMilli,
    unitCostPaise,
    unitPricePaise,
    sortOrder,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visit_parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisitPart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    }
    if (data.containsKey('part_name')) {
      context.handle(
        _partNameMeta,
        partName.isAcceptableOrUnknown(data['part_name']!, _partNameMeta),
      );
    } else if (isInserting) {
      context.missing(_partNameMeta);
    }
    if (data.containsKey('part_number')) {
      context.handle(
        _partNumberMeta,
        partNumber.isAcceptableOrUnknown(data['part_number']!, _partNumberMeta),
      );
    }
    if (data.containsKey('qty_milli')) {
      context.handle(
        _qtyMilliMeta,
        qtyMilli.isAcceptableOrUnknown(data['qty_milli']!, _qtyMilliMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMilliMeta);
    }
    if (data.containsKey('unit_cost_paise')) {
      context.handle(
        _unitCostPaiseMeta,
        unitCostPaise.isAcceptableOrUnknown(
          data['unit_cost_paise']!,
          _unitCostPaiseMeta,
        ),
      );
    }
    if (data.containsKey('unit_price_paise')) {
      context.handle(
        _unitPricePaiseMeta,
        unitPricePaise.isAcceptableOrUnknown(
          data['unit_price_paise']!,
          _unitPricePaiseMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VisitPart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisitPart(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      ),
      partName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_name'],
      )!,
      partNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_number'],
      ),
      qtyMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_milli'],
      )!,
      unitCostPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_paise'],
      ),
      unitPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_paise'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $VisitPartsTable createAlias(String alias) {
    return $VisitPartsTable(attachedDatabase, alias);
  }
}

class VisitPart extends DataClass implements Insertable<VisitPart> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String visitId;
  final String? partId;
  final String partName;
  final String? partNumber;
  final int qtyMilli;
  final int? unitCostPaise;
  final int unitPricePaise;
  final int sortOrder;
  final DateTime? deletedAt;
  const VisitPart({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.visitId,
    this.partId,
    required this.partName,
    this.partNumber,
    required this.qtyMilli,
    this.unitCostPaise,
    required this.unitPricePaise,
    required this.sortOrder,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['visit_id'] = Variable<String>(visitId);
    if (!nullToAbsent || partId != null) {
      map['part_id'] = Variable<String>(partId);
    }
    map['part_name'] = Variable<String>(partName);
    if (!nullToAbsent || partNumber != null) {
      map['part_number'] = Variable<String>(partNumber);
    }
    map['qty_milli'] = Variable<int>(qtyMilli);
    if (!nullToAbsent || unitCostPaise != null) {
      map['unit_cost_paise'] = Variable<int>(unitCostPaise);
    }
    map['unit_price_paise'] = Variable<int>(unitPricePaise);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  VisitPartsCompanion toCompanion(bool nullToAbsent) {
    return VisitPartsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      visitId: Value(visitId),
      partId: partId == null && nullToAbsent
          ? const Value.absent()
          : Value(partId),
      partName: Value(partName),
      partNumber: partNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(partNumber),
      qtyMilli: Value(qtyMilli),
      unitCostPaise: unitCostPaise == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCostPaise),
      unitPricePaise: Value(unitPricePaise),
      sortOrder: Value(sortOrder),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory VisitPart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisitPart(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      visitId: serializer.fromJson<String>(json['visitId']),
      partId: serializer.fromJson<String?>(json['partId']),
      partName: serializer.fromJson<String>(json['partName']),
      partNumber: serializer.fromJson<String?>(json['partNumber']),
      qtyMilli: serializer.fromJson<int>(json['qtyMilli']),
      unitCostPaise: serializer.fromJson<int?>(json['unitCostPaise']),
      unitPricePaise: serializer.fromJson<int>(json['unitPricePaise']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'visitId': serializer.toJson<String>(visitId),
      'partId': serializer.toJson<String?>(partId),
      'partName': serializer.toJson<String>(partName),
      'partNumber': serializer.toJson<String?>(partNumber),
      'qtyMilli': serializer.toJson<int>(qtyMilli),
      'unitCostPaise': serializer.toJson<int?>(unitCostPaise),
      'unitPricePaise': serializer.toJson<int>(unitPricePaise),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  VisitPart copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? visitId,
    Value<String?> partId = const Value.absent(),
    String? partName,
    Value<String?> partNumber = const Value.absent(),
    int? qtyMilli,
    Value<int?> unitCostPaise = const Value.absent(),
    int? unitPricePaise,
    int? sortOrder,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => VisitPart(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    visitId: visitId ?? this.visitId,
    partId: partId.present ? partId.value : this.partId,
    partName: partName ?? this.partName,
    partNumber: partNumber.present ? partNumber.value : this.partNumber,
    qtyMilli: qtyMilli ?? this.qtyMilli,
    unitCostPaise: unitCostPaise.present
        ? unitCostPaise.value
        : this.unitCostPaise,
    unitPricePaise: unitPricePaise ?? this.unitPricePaise,
    sortOrder: sortOrder ?? this.sortOrder,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  VisitPart copyWithCompanion(VisitPartsCompanion data) {
    return VisitPart(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      partId: data.partId.present ? data.partId.value : this.partId,
      partName: data.partName.present ? data.partName.value : this.partName,
      partNumber: data.partNumber.present
          ? data.partNumber.value
          : this.partNumber,
      qtyMilli: data.qtyMilli.present ? data.qtyMilli.value : this.qtyMilli,
      unitCostPaise: data.unitCostPaise.present
          ? data.unitCostPaise.value
          : this.unitCostPaise,
      unitPricePaise: data.unitPricePaise.present
          ? data.unitPricePaise.value
          : this.unitPricePaise,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisitPart(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('visitId: $visitId, ')
          ..write('partId: $partId, ')
          ..write('partName: $partName, ')
          ..write('partNumber: $partNumber, ')
          ..write('qtyMilli: $qtyMilli, ')
          ..write('unitCostPaise: $unitCostPaise, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    visitId,
    partId,
    partName,
    partNumber,
    qtyMilli,
    unitCostPaise,
    unitPricePaise,
    sortOrder,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisitPart &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.visitId == this.visitId &&
          other.partId == this.partId &&
          other.partName == this.partName &&
          other.partNumber == this.partNumber &&
          other.qtyMilli == this.qtyMilli &&
          other.unitCostPaise == this.unitCostPaise &&
          other.unitPricePaise == this.unitPricePaise &&
          other.sortOrder == this.sortOrder &&
          other.deletedAt == this.deletedAt);
}

class VisitPartsCompanion extends UpdateCompanion<VisitPart> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> visitId;
  final Value<String?> partId;
  final Value<String> partName;
  final Value<String?> partNumber;
  final Value<int> qtyMilli;
  final Value<int?> unitCostPaise;
  final Value<int> unitPricePaise;
  final Value<int> sortOrder;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const VisitPartsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.visitId = const Value.absent(),
    this.partId = const Value.absent(),
    this.partName = const Value.absent(),
    this.partNumber = const Value.absent(),
    this.qtyMilli = const Value.absent(),
    this.unitCostPaise = const Value.absent(),
    this.unitPricePaise = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisitPartsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String visitId,
    this.partId = const Value.absent(),
    required String partName,
    this.partNumber = const Value.absent(),
    required int qtyMilli,
    this.unitCostPaise = const Value.absent(),
    this.unitPricePaise = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       visitId = Value(visitId),
       partName = Value(partName),
       qtyMilli = Value(qtyMilli);
  static Insertable<VisitPart> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? visitId,
    Expression<String>? partId,
    Expression<String>? partName,
    Expression<String>? partNumber,
    Expression<int>? qtyMilli,
    Expression<int>? unitCostPaise,
    Expression<int>? unitPricePaise,
    Expression<int>? sortOrder,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (visitId != null) 'visit_id': visitId,
      if (partId != null) 'part_id': partId,
      if (partName != null) 'part_name': partName,
      if (partNumber != null) 'part_number': partNumber,
      if (qtyMilli != null) 'qty_milli': qtyMilli,
      if (unitCostPaise != null) 'unit_cost_paise': unitCostPaise,
      if (unitPricePaise != null) 'unit_price_paise': unitPricePaise,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisitPartsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? visitId,
    Value<String?>? partId,
    Value<String>? partName,
    Value<String?>? partNumber,
    Value<int>? qtyMilli,
    Value<int?>? unitCostPaise,
    Value<int>? unitPricePaise,
    Value<int>? sortOrder,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return VisitPartsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      visitId: visitId ?? this.visitId,
      partId: partId ?? this.partId,
      partName: partName ?? this.partName,
      partNumber: partNumber ?? this.partNumber,
      qtyMilli: qtyMilli ?? this.qtyMilli,
      unitCostPaise: unitCostPaise ?? this.unitCostPaise,
      unitPricePaise: unitPricePaise ?? this.unitPricePaise,
      sortOrder: sortOrder ?? this.sortOrder,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (partName.present) {
      map['part_name'] = Variable<String>(partName.value);
    }
    if (partNumber.present) {
      map['part_number'] = Variable<String>(partNumber.value);
    }
    if (qtyMilli.present) {
      map['qty_milli'] = Variable<int>(qtyMilli.value);
    }
    if (unitCostPaise.present) {
      map['unit_cost_paise'] = Variable<int>(unitCostPaise.value);
    }
    if (unitPricePaise.present) {
      map['unit_price_paise'] = Variable<int>(unitPricePaise.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitPartsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('visitId: $visitId, ')
          ..write('partId: $partId, ')
          ..write('partName: $partName, ')
          ..write('partNumber: $partNumber, ')
          ..write('qtyMilli: $qtyMilli, ')
          ..write('unitCostPaise: $unitCostPaise, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id)',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMilliMeta = const VerificationMeta(
    'qtyMilli',
  );
  @override
  late final GeneratedColumn<int> qtyMilli = GeneratedColumn<int>(
    'qty_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostPaiseMeta = const VerificationMeta(
    'unitCostPaise',
  );
  @override
  late final GeneratedColumn<int> unitCostPaise = GeneratedColumn<int>(
    'unit_cost_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visitPartIdMeta = const VerificationMeta(
    'visitPartId',
  );
  @override
  late final GeneratedColumn<String> visitPartId = GeneratedColumn<String>(
    'visit_part_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredOnMeta = const VerificationMeta(
    'occurredOn',
  );
  @override
  late final GeneratedColumn<String> occurredOn = GeneratedColumn<String>(
    'occurred_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    partId,
    kind,
    qtyMilli,
    unitCostPaise,
    visitId,
    visitPartId,
    occurredOn,
    notes,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('qty_milli')) {
      context.handle(
        _qtyMilliMeta,
        qtyMilli.isAcceptableOrUnknown(data['qty_milli']!, _qtyMilliMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMilliMeta);
    }
    if (data.containsKey('unit_cost_paise')) {
      context.handle(
        _unitCostPaiseMeta,
        unitCostPaise.isAcceptableOrUnknown(
          data['unit_cost_paise']!,
          _unitCostPaiseMeta,
        ),
      );
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    }
    if (data.containsKey('visit_part_id')) {
      context.handle(
        _visitPartIdMeta,
        visitPartId.isAcceptableOrUnknown(
          data['visit_part_id']!,
          _visitPartIdMeta,
        ),
      );
    }
    if (data.containsKey('occurred_on')) {
      context.handle(
        _occurredOnMeta,
        occurredOn.isAcceptableOrUnknown(data['occurred_on']!, _occurredOnMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredOnMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      qtyMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_milli'],
      )!,
      unitCostPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_paise'],
      ),
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      ),
      visitPartId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_part_id'],
      ),
      occurredOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurred_on'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String partId;
  final String kind;
  final int qtyMilli;
  final int? unitCostPaise;
  final String? visitId;
  final String? visitPartId;
  final String occurredOn;
  final String? notes;
  final DateTime? deletedAt;
  const StockMovement({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.partId,
    required this.kind,
    required this.qtyMilli,
    this.unitCostPaise,
    this.visitId,
    this.visitPartId,
    required this.occurredOn,
    this.notes,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['part_id'] = Variable<String>(partId);
    map['kind'] = Variable<String>(kind);
    map['qty_milli'] = Variable<int>(qtyMilli);
    if (!nullToAbsent || unitCostPaise != null) {
      map['unit_cost_paise'] = Variable<int>(unitCostPaise);
    }
    if (!nullToAbsent || visitId != null) {
      map['visit_id'] = Variable<String>(visitId);
    }
    if (!nullToAbsent || visitPartId != null) {
      map['visit_part_id'] = Variable<String>(visitPartId);
    }
    map['occurred_on'] = Variable<String>(occurredOn);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      partId: Value(partId),
      kind: Value(kind),
      qtyMilli: Value(qtyMilli),
      unitCostPaise: unitCostPaise == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCostPaise),
      visitId: visitId == null && nullToAbsent
          ? const Value.absent()
          : Value(visitId),
      visitPartId: visitPartId == null && nullToAbsent
          ? const Value.absent()
          : Value(visitPartId),
      occurredOn: Value(occurredOn),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory StockMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      partId: serializer.fromJson<String>(json['partId']),
      kind: serializer.fromJson<String>(json['kind']),
      qtyMilli: serializer.fromJson<int>(json['qtyMilli']),
      unitCostPaise: serializer.fromJson<int?>(json['unitCostPaise']),
      visitId: serializer.fromJson<String?>(json['visitId']),
      visitPartId: serializer.fromJson<String?>(json['visitPartId']),
      occurredOn: serializer.fromJson<String>(json['occurredOn']),
      notes: serializer.fromJson<String?>(json['notes']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'partId': serializer.toJson<String>(partId),
      'kind': serializer.toJson<String>(kind),
      'qtyMilli': serializer.toJson<int>(qtyMilli),
      'unitCostPaise': serializer.toJson<int?>(unitCostPaise),
      'visitId': serializer.toJson<String?>(visitId),
      'visitPartId': serializer.toJson<String?>(visitPartId),
      'occurredOn': serializer.toJson<String>(occurredOn),
      'notes': serializer.toJson<String?>(notes),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  StockMovement copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? partId,
    String? kind,
    int? qtyMilli,
    Value<int?> unitCostPaise = const Value.absent(),
    Value<String?> visitId = const Value.absent(),
    Value<String?> visitPartId = const Value.absent(),
    String? occurredOn,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => StockMovement(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    partId: partId ?? this.partId,
    kind: kind ?? this.kind,
    qtyMilli: qtyMilli ?? this.qtyMilli,
    unitCostPaise: unitCostPaise.present
        ? unitCostPaise.value
        : this.unitCostPaise,
    visitId: visitId.present ? visitId.value : this.visitId,
    visitPartId: visitPartId.present ? visitPartId.value : this.visitPartId,
    occurredOn: occurredOn ?? this.occurredOn,
    notes: notes.present ? notes.value : this.notes,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  StockMovement copyWithCompanion(StockMovementsCompanion data) {
    return StockMovement(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      partId: data.partId.present ? data.partId.value : this.partId,
      kind: data.kind.present ? data.kind.value : this.kind,
      qtyMilli: data.qtyMilli.present ? data.qtyMilli.value : this.qtyMilli,
      unitCostPaise: data.unitCostPaise.present
          ? data.unitCostPaise.value
          : this.unitCostPaise,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      visitPartId: data.visitPartId.present
          ? data.visitPartId.value
          : this.visitPartId,
      occurredOn: data.occurredOn.present
          ? data.occurredOn.value
          : this.occurredOn,
      notes: data.notes.present ? data.notes.value : this.notes,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('partId: $partId, ')
          ..write('kind: $kind, ')
          ..write('qtyMilli: $qtyMilli, ')
          ..write('unitCostPaise: $unitCostPaise, ')
          ..write('visitId: $visitId, ')
          ..write('visitPartId: $visitPartId, ')
          ..write('occurredOn: $occurredOn, ')
          ..write('notes: $notes, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    partId,
    kind,
    qtyMilli,
    unitCostPaise,
    visitId,
    visitPartId,
    occurredOn,
    notes,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.partId == this.partId &&
          other.kind == this.kind &&
          other.qtyMilli == this.qtyMilli &&
          other.unitCostPaise == this.unitCostPaise &&
          other.visitId == this.visitId &&
          other.visitPartId == this.visitPartId &&
          other.occurredOn == this.occurredOn &&
          other.notes == this.notes &&
          other.deletedAt == this.deletedAt);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> partId;
  final Value<String> kind;
  final Value<int> qtyMilli;
  final Value<int?> unitCostPaise;
  final Value<String?> visitId;
  final Value<String?> visitPartId;
  final Value<String> occurredOn;
  final Value<String?> notes;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.partId = const Value.absent(),
    this.kind = const Value.absent(),
    this.qtyMilli = const Value.absent(),
    this.unitCostPaise = const Value.absent(),
    this.visitId = const Value.absent(),
    this.visitPartId = const Value.absent(),
    this.occurredOn = const Value.absent(),
    this.notes = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String partId,
    required String kind,
    required int qtyMilli,
    this.unitCostPaise = const Value.absent(),
    this.visitId = const Value.absent(),
    this.visitPartId = const Value.absent(),
    required String occurredOn,
    this.notes = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       partId = Value(partId),
       kind = Value(kind),
       qtyMilli = Value(qtyMilli),
       occurredOn = Value(occurredOn);
  static Insertable<StockMovement> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? partId,
    Expression<String>? kind,
    Expression<int>? qtyMilli,
    Expression<int>? unitCostPaise,
    Expression<String>? visitId,
    Expression<String>? visitPartId,
    Expression<String>? occurredOn,
    Expression<String>? notes,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (partId != null) 'part_id': partId,
      if (kind != null) 'kind': kind,
      if (qtyMilli != null) 'qty_milli': qtyMilli,
      if (unitCostPaise != null) 'unit_cost_paise': unitCostPaise,
      if (visitId != null) 'visit_id': visitId,
      if (visitPartId != null) 'visit_part_id': visitPartId,
      if (occurredOn != null) 'occurred_on': occurredOn,
      if (notes != null) 'notes': notes,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockMovementsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? partId,
    Value<String>? kind,
    Value<int>? qtyMilli,
    Value<int?>? unitCostPaise,
    Value<String?>? visitId,
    Value<String?>? visitPartId,
    Value<String>? occurredOn,
    Value<String?>? notes,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      partId: partId ?? this.partId,
      kind: kind ?? this.kind,
      qtyMilli: qtyMilli ?? this.qtyMilli,
      unitCostPaise: unitCostPaise ?? this.unitCostPaise,
      visitId: visitId ?? this.visitId,
      visitPartId: visitPartId ?? this.visitPartId,
      occurredOn: occurredOn ?? this.occurredOn,
      notes: notes ?? this.notes,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (qtyMilli.present) {
      map['qty_milli'] = Variable<int>(qtyMilli.value);
    }
    if (unitCostPaise.present) {
      map['unit_cost_paise'] = Variable<int>(unitCostPaise.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (visitPartId.present) {
      map['visit_part_id'] = Variable<String>(visitPartId.value);
    }
    if (occurredOn.present) {
      map['occurred_on'] = Variable<String>(occurredOn.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('partId: $partId, ')
          ..write('kind: $kind, ')
          ..write('qtyMilli: $qtyMilli, ')
          ..write('unitCostPaise: $unitCostPaise, ')
          ..write('visitId: $visitId, ')
          ..write('visitPartId: $visitPartId, ')
          ..write('occurredOn: $occurredOn, ')
          ..write('notes: $notes, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _invoiceNoMeta = const VerificationMeta(
    'invoiceNo',
  );
  @override
  late final GeneratedColumn<String> invoiceNo = GeneratedColumn<String>(
    'invoice_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id)',
    ),
  );
  static const VerificationMeta _invoiceDateMeta = const VerificationMeta(
    'invoiceDate',
  );
  @override
  late final GeneratedColumn<String> invoiceDate = GeneratedColumn<String>(
    'invoice_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billToNameMeta = const VerificationMeta(
    'billToName',
  );
  @override
  late final GeneratedColumn<String> billToName = GeneratedColumn<String>(
    'bill_to_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billToAddressMeta = const VerificationMeta(
    'billToAddress',
  );
  @override
  late final GeneratedColumn<String> billToAddress = GeneratedColumn<String>(
    'bill_to_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billToPhoneMeta = const VerificationMeta(
    'billToPhone',
  );
  @override
  late final GeneratedColumn<String> billToPhone = GeneratedColumn<String>(
    'bill_to_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billToGstinMeta = const VerificationMeta(
    'billToGstin',
  );
  @override
  late final GeneratedColumn<String> billToGstin = GeneratedColumn<String>(
    'bill_to_gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountPaiseMeta = const VerificationMeta(
    'discountPaise',
  );
  @override
  late final GeneratedColumn<int> discountPaise = GeneratedColumn<int>(
    'discount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxLabelMeta = const VerificationMeta(
    'taxLabel',
  );
  @override
  late final GeneratedColumn<String> taxLabel = GeneratedColumn<String>(
    'tax_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxRateBpMeta = const VerificationMeta(
    'taxRateBp',
  );
  @override
  late final GeneratedColumn<int> taxRateBp = GeneratedColumn<int>(
    'tax_rate_bp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subtotalPaiseMeta = const VerificationMeta(
    'subtotalPaise',
  );
  @override
  late final GeneratedColumn<int> subtotalPaise = GeneratedColumn<int>(
    'subtotal_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxPaiseMeta = const VerificationMeta(
    'taxPaise',
  );
  @override
  late final GeneratedColumn<int> taxPaise = GeneratedColumn<int>(
    'tax_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalPaiseMeta = const VerificationMeta(
    'totalPaise',
  );
  @override
  late final GeneratedColumn<int> totalPaise = GeneratedColumn<int>(
    'total_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelReasonMeta = const VerificationMeta(
    'cancelReason',
  );
  @override
  late final GeneratedColumn<String> cancelReason = GeneratedColumn<String>(
    'cancel_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    invoiceNo,
    companyId,
    invoiceDate,
    dueDate,
    billToName,
    billToAddress,
    billToPhone,
    billToGstin,
    discountPaise,
    taxLabel,
    taxRateBp,
    subtotalPaise,
    taxPaise,
    totalPaise,
    notes,
    cancelledAt,
    cancelReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('invoice_no')) {
      context.handle(
        _invoiceNoMeta,
        invoiceNo.isAcceptableOrUnknown(data['invoice_no']!, _invoiceNoMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceNoMeta);
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('invoice_date')) {
      context.handle(
        _invoiceDateMeta,
        invoiceDate.isAcceptableOrUnknown(
          data['invoice_date']!,
          _invoiceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('bill_to_name')) {
      context.handle(
        _billToNameMeta,
        billToName.isAcceptableOrUnknown(
          data['bill_to_name']!,
          _billToNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billToNameMeta);
    }
    if (data.containsKey('bill_to_address')) {
      context.handle(
        _billToAddressMeta,
        billToAddress.isAcceptableOrUnknown(
          data['bill_to_address']!,
          _billToAddressMeta,
        ),
      );
    }
    if (data.containsKey('bill_to_phone')) {
      context.handle(
        _billToPhoneMeta,
        billToPhone.isAcceptableOrUnknown(
          data['bill_to_phone']!,
          _billToPhoneMeta,
        ),
      );
    }
    if (data.containsKey('bill_to_gstin')) {
      context.handle(
        _billToGstinMeta,
        billToGstin.isAcceptableOrUnknown(
          data['bill_to_gstin']!,
          _billToGstinMeta,
        ),
      );
    }
    if (data.containsKey('discount_paise')) {
      context.handle(
        _discountPaiseMeta,
        discountPaise.isAcceptableOrUnknown(
          data['discount_paise']!,
          _discountPaiseMeta,
        ),
      );
    }
    if (data.containsKey('tax_label')) {
      context.handle(
        _taxLabelMeta,
        taxLabel.isAcceptableOrUnknown(data['tax_label']!, _taxLabelMeta),
      );
    }
    if (data.containsKey('tax_rate_bp')) {
      context.handle(
        _taxRateBpMeta,
        taxRateBp.isAcceptableOrUnknown(data['tax_rate_bp']!, _taxRateBpMeta),
      );
    }
    if (data.containsKey('subtotal_paise')) {
      context.handle(
        _subtotalPaiseMeta,
        subtotalPaise.isAcceptableOrUnknown(
          data['subtotal_paise']!,
          _subtotalPaiseMeta,
        ),
      );
    }
    if (data.containsKey('tax_paise')) {
      context.handle(
        _taxPaiseMeta,
        taxPaise.isAcceptableOrUnknown(data['tax_paise']!, _taxPaiseMeta),
      );
    }
    if (data.containsKey('total_paise')) {
      context.handle(
        _totalPaiseMeta,
        totalPaise.isAcceptableOrUnknown(data['total_paise']!, _totalPaiseMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
        ),
      );
    }
    if (data.containsKey('cancel_reason')) {
      context.handle(
        _cancelReasonMeta,
        cancelReason.isAcceptableOrUnknown(
          data['cancel_reason']!,
          _cancelReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      invoiceNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_no'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      )!,
      invoiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      billToName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_to_name'],
      )!,
      billToAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_to_address'],
      ),
      billToPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_to_phone'],
      ),
      billToGstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_to_gstin'],
      ),
      discountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_paise'],
      )!,
      taxLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_label'],
      ),
      taxRateBp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_rate_bp'],
      )!,
      subtotalPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_paise'],
      )!,
      taxPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_paise'],
      )!,
      totalPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_paise'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
      cancelReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancel_reason'],
      ),
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String invoiceNo;
  final String companyId;
  final String invoiceDate;
  final String? dueDate;
  final String billToName;
  final String? billToAddress;
  final String? billToPhone;
  final String? billToGstin;
  final int discountPaise;
  final String? taxLabel;
  final int taxRateBp;
  final int subtotalPaise;
  final int taxPaise;
  final int totalPaise;
  final String? notes;
  final DateTime? cancelledAt;
  final String? cancelReason;
  const Invoice({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.invoiceNo,
    required this.companyId,
    required this.invoiceDate,
    this.dueDate,
    required this.billToName,
    this.billToAddress,
    this.billToPhone,
    this.billToGstin,
    required this.discountPaise,
    this.taxLabel,
    required this.taxRateBp,
    required this.subtotalPaise,
    required this.taxPaise,
    required this.totalPaise,
    this.notes,
    this.cancelledAt,
    this.cancelReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['invoice_no'] = Variable<String>(invoiceNo);
    map['company_id'] = Variable<String>(companyId);
    map['invoice_date'] = Variable<String>(invoiceDate);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    map['bill_to_name'] = Variable<String>(billToName);
    if (!nullToAbsent || billToAddress != null) {
      map['bill_to_address'] = Variable<String>(billToAddress);
    }
    if (!nullToAbsent || billToPhone != null) {
      map['bill_to_phone'] = Variable<String>(billToPhone);
    }
    if (!nullToAbsent || billToGstin != null) {
      map['bill_to_gstin'] = Variable<String>(billToGstin);
    }
    map['discount_paise'] = Variable<int>(discountPaise);
    if (!nullToAbsent || taxLabel != null) {
      map['tax_label'] = Variable<String>(taxLabel);
    }
    map['tax_rate_bp'] = Variable<int>(taxRateBp);
    map['subtotal_paise'] = Variable<int>(subtotalPaise);
    map['tax_paise'] = Variable<int>(taxPaise);
    map['total_paise'] = Variable<int>(totalPaise);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    if (!nullToAbsent || cancelReason != null) {
      map['cancel_reason'] = Variable<String>(cancelReason);
    }
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      invoiceNo: Value(invoiceNo),
      companyId: Value(companyId),
      invoiceDate: Value(invoiceDate),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      billToName: Value(billToName),
      billToAddress: billToAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(billToAddress),
      billToPhone: billToPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(billToPhone),
      billToGstin: billToGstin == null && nullToAbsent
          ? const Value.absent()
          : Value(billToGstin),
      discountPaise: Value(discountPaise),
      taxLabel: taxLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(taxLabel),
      taxRateBp: Value(taxRateBp),
      subtotalPaise: Value(subtotalPaise),
      taxPaise: Value(taxPaise),
      totalPaise: Value(totalPaise),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
      cancelReason: cancelReason == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelReason),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      invoiceNo: serializer.fromJson<String>(json['invoiceNo']),
      companyId: serializer.fromJson<String>(json['companyId']),
      invoiceDate: serializer.fromJson<String>(json['invoiceDate']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      billToName: serializer.fromJson<String>(json['billToName']),
      billToAddress: serializer.fromJson<String?>(json['billToAddress']),
      billToPhone: serializer.fromJson<String?>(json['billToPhone']),
      billToGstin: serializer.fromJson<String?>(json['billToGstin']),
      discountPaise: serializer.fromJson<int>(json['discountPaise']),
      taxLabel: serializer.fromJson<String?>(json['taxLabel']),
      taxRateBp: serializer.fromJson<int>(json['taxRateBp']),
      subtotalPaise: serializer.fromJson<int>(json['subtotalPaise']),
      taxPaise: serializer.fromJson<int>(json['taxPaise']),
      totalPaise: serializer.fromJson<int>(json['totalPaise']),
      notes: serializer.fromJson<String?>(json['notes']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
      cancelReason: serializer.fromJson<String?>(json['cancelReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'invoiceNo': serializer.toJson<String>(invoiceNo),
      'companyId': serializer.toJson<String>(companyId),
      'invoiceDate': serializer.toJson<String>(invoiceDate),
      'dueDate': serializer.toJson<String?>(dueDate),
      'billToName': serializer.toJson<String>(billToName),
      'billToAddress': serializer.toJson<String?>(billToAddress),
      'billToPhone': serializer.toJson<String?>(billToPhone),
      'billToGstin': serializer.toJson<String?>(billToGstin),
      'discountPaise': serializer.toJson<int>(discountPaise),
      'taxLabel': serializer.toJson<String?>(taxLabel),
      'taxRateBp': serializer.toJson<int>(taxRateBp),
      'subtotalPaise': serializer.toJson<int>(subtotalPaise),
      'taxPaise': serializer.toJson<int>(taxPaise),
      'totalPaise': serializer.toJson<int>(totalPaise),
      'notes': serializer.toJson<String?>(notes),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
      'cancelReason': serializer.toJson<String?>(cancelReason),
    };
  }

  Invoice copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? invoiceNo,
    String? companyId,
    String? invoiceDate,
    Value<String?> dueDate = const Value.absent(),
    String? billToName,
    Value<String?> billToAddress = const Value.absent(),
    Value<String?> billToPhone = const Value.absent(),
    Value<String?> billToGstin = const Value.absent(),
    int? discountPaise,
    Value<String?> taxLabel = const Value.absent(),
    int? taxRateBp,
    int? subtotalPaise,
    int? taxPaise,
    int? totalPaise,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> cancelledAt = const Value.absent(),
    Value<String?> cancelReason = const Value.absent(),
  }) => Invoice(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    invoiceNo: invoiceNo ?? this.invoiceNo,
    companyId: companyId ?? this.companyId,
    invoiceDate: invoiceDate ?? this.invoiceDate,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    billToName: billToName ?? this.billToName,
    billToAddress: billToAddress.present
        ? billToAddress.value
        : this.billToAddress,
    billToPhone: billToPhone.present ? billToPhone.value : this.billToPhone,
    billToGstin: billToGstin.present ? billToGstin.value : this.billToGstin,
    discountPaise: discountPaise ?? this.discountPaise,
    taxLabel: taxLabel.present ? taxLabel.value : this.taxLabel,
    taxRateBp: taxRateBp ?? this.taxRateBp,
    subtotalPaise: subtotalPaise ?? this.subtotalPaise,
    taxPaise: taxPaise ?? this.taxPaise,
    totalPaise: totalPaise ?? this.totalPaise,
    notes: notes.present ? notes.value : this.notes,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
    cancelReason: cancelReason.present ? cancelReason.value : this.cancelReason,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      invoiceNo: data.invoiceNo.present ? data.invoiceNo.value : this.invoiceNo,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      invoiceDate: data.invoiceDate.present
          ? data.invoiceDate.value
          : this.invoiceDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      billToName: data.billToName.present
          ? data.billToName.value
          : this.billToName,
      billToAddress: data.billToAddress.present
          ? data.billToAddress.value
          : this.billToAddress,
      billToPhone: data.billToPhone.present
          ? data.billToPhone.value
          : this.billToPhone,
      billToGstin: data.billToGstin.present
          ? data.billToGstin.value
          : this.billToGstin,
      discountPaise: data.discountPaise.present
          ? data.discountPaise.value
          : this.discountPaise,
      taxLabel: data.taxLabel.present ? data.taxLabel.value : this.taxLabel,
      taxRateBp: data.taxRateBp.present ? data.taxRateBp.value : this.taxRateBp,
      subtotalPaise: data.subtotalPaise.present
          ? data.subtotalPaise.value
          : this.subtotalPaise,
      taxPaise: data.taxPaise.present ? data.taxPaise.value : this.taxPaise,
      totalPaise: data.totalPaise.present
          ? data.totalPaise.value
          : this.totalPaise,
      notes: data.notes.present ? data.notes.value : this.notes,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
      cancelReason: data.cancelReason.present
          ? data.cancelReason.value
          : this.cancelReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('invoiceNo: $invoiceNo, ')
          ..write('companyId: $companyId, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('billToName: $billToName, ')
          ..write('billToAddress: $billToAddress, ')
          ..write('billToPhone: $billToPhone, ')
          ..write('billToGstin: $billToGstin, ')
          ..write('discountPaise: $discountPaise, ')
          ..write('taxLabel: $taxLabel, ')
          ..write('taxRateBp: $taxRateBp, ')
          ..write('subtotalPaise: $subtotalPaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('notes: $notes, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('cancelReason: $cancelReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    serverRev,
    invoiceNo,
    companyId,
    invoiceDate,
    dueDate,
    billToName,
    billToAddress,
    billToPhone,
    billToGstin,
    discountPaise,
    taxLabel,
    taxRateBp,
    subtotalPaise,
    taxPaise,
    totalPaise,
    notes,
    cancelledAt,
    cancelReason,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.invoiceNo == this.invoiceNo &&
          other.companyId == this.companyId &&
          other.invoiceDate == this.invoiceDate &&
          other.dueDate == this.dueDate &&
          other.billToName == this.billToName &&
          other.billToAddress == this.billToAddress &&
          other.billToPhone == this.billToPhone &&
          other.billToGstin == this.billToGstin &&
          other.discountPaise == this.discountPaise &&
          other.taxLabel == this.taxLabel &&
          other.taxRateBp == this.taxRateBp &&
          other.subtotalPaise == this.subtotalPaise &&
          other.taxPaise == this.taxPaise &&
          other.totalPaise == this.totalPaise &&
          other.notes == this.notes &&
          other.cancelledAt == this.cancelledAt &&
          other.cancelReason == this.cancelReason);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> invoiceNo;
  final Value<String> companyId;
  final Value<String> invoiceDate;
  final Value<String?> dueDate;
  final Value<String> billToName;
  final Value<String?> billToAddress;
  final Value<String?> billToPhone;
  final Value<String?> billToGstin;
  final Value<int> discountPaise;
  final Value<String?> taxLabel;
  final Value<int> taxRateBp;
  final Value<int> subtotalPaise;
  final Value<int> taxPaise;
  final Value<int> totalPaise;
  final Value<String?> notes;
  final Value<DateTime?> cancelledAt;
  final Value<String?> cancelReason;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.invoiceNo = const Value.absent(),
    this.companyId = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.billToName = const Value.absent(),
    this.billToAddress = const Value.absent(),
    this.billToPhone = const Value.absent(),
    this.billToGstin = const Value.absent(),
    this.discountPaise = const Value.absent(),
    this.taxLabel = const Value.absent(),
    this.taxRateBp = const Value.absent(),
    this.subtotalPaise = const Value.absent(),
    this.taxPaise = const Value.absent(),
    this.totalPaise = const Value.absent(),
    this.notes = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.cancelReason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String invoiceNo,
    required String companyId,
    required String invoiceDate,
    this.dueDate = const Value.absent(),
    required String billToName,
    this.billToAddress = const Value.absent(),
    this.billToPhone = const Value.absent(),
    this.billToGstin = const Value.absent(),
    this.discountPaise = const Value.absent(),
    this.taxLabel = const Value.absent(),
    this.taxRateBp = const Value.absent(),
    this.subtotalPaise = const Value.absent(),
    this.taxPaise = const Value.absent(),
    this.totalPaise = const Value.absent(),
    this.notes = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.cancelReason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       invoiceNo = Value(invoiceNo),
       companyId = Value(companyId),
       invoiceDate = Value(invoiceDate),
       billToName = Value(billToName);
  static Insertable<Invoice> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? invoiceNo,
    Expression<String>? companyId,
    Expression<String>? invoiceDate,
    Expression<String>? dueDate,
    Expression<String>? billToName,
    Expression<String>? billToAddress,
    Expression<String>? billToPhone,
    Expression<String>? billToGstin,
    Expression<int>? discountPaise,
    Expression<String>? taxLabel,
    Expression<int>? taxRateBp,
    Expression<int>? subtotalPaise,
    Expression<int>? taxPaise,
    Expression<int>? totalPaise,
    Expression<String>? notes,
    Expression<DateTime>? cancelledAt,
    Expression<String>? cancelReason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (invoiceNo != null) 'invoice_no': invoiceNo,
      if (companyId != null) 'company_id': companyId,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (dueDate != null) 'due_date': dueDate,
      if (billToName != null) 'bill_to_name': billToName,
      if (billToAddress != null) 'bill_to_address': billToAddress,
      if (billToPhone != null) 'bill_to_phone': billToPhone,
      if (billToGstin != null) 'bill_to_gstin': billToGstin,
      if (discountPaise != null) 'discount_paise': discountPaise,
      if (taxLabel != null) 'tax_label': taxLabel,
      if (taxRateBp != null) 'tax_rate_bp': taxRateBp,
      if (subtotalPaise != null) 'subtotal_paise': subtotalPaise,
      if (taxPaise != null) 'tax_paise': taxPaise,
      if (totalPaise != null) 'total_paise': totalPaise,
      if (notes != null) 'notes': notes,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
      if (cancelReason != null) 'cancel_reason': cancelReason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? invoiceNo,
    Value<String>? companyId,
    Value<String>? invoiceDate,
    Value<String?>? dueDate,
    Value<String>? billToName,
    Value<String?>? billToAddress,
    Value<String?>? billToPhone,
    Value<String?>? billToGstin,
    Value<int>? discountPaise,
    Value<String?>? taxLabel,
    Value<int>? taxRateBp,
    Value<int>? subtotalPaise,
    Value<int>? taxPaise,
    Value<int>? totalPaise,
    Value<String?>? notes,
    Value<DateTime?>? cancelledAt,
    Value<String?>? cancelReason,
    Value<int>? rowid,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      companyId: companyId ?? this.companyId,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      dueDate: dueDate ?? this.dueDate,
      billToName: billToName ?? this.billToName,
      billToAddress: billToAddress ?? this.billToAddress,
      billToPhone: billToPhone ?? this.billToPhone,
      billToGstin: billToGstin ?? this.billToGstin,
      discountPaise: discountPaise ?? this.discountPaise,
      taxLabel: taxLabel ?? this.taxLabel,
      taxRateBp: taxRateBp ?? this.taxRateBp,
      subtotalPaise: subtotalPaise ?? this.subtotalPaise,
      taxPaise: taxPaise ?? this.taxPaise,
      totalPaise: totalPaise ?? this.totalPaise,
      notes: notes ?? this.notes,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelReason: cancelReason ?? this.cancelReason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (invoiceNo.present) {
      map['invoice_no'] = Variable<String>(invoiceNo.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (invoiceDate.present) {
      map['invoice_date'] = Variable<String>(invoiceDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (billToName.present) {
      map['bill_to_name'] = Variable<String>(billToName.value);
    }
    if (billToAddress.present) {
      map['bill_to_address'] = Variable<String>(billToAddress.value);
    }
    if (billToPhone.present) {
      map['bill_to_phone'] = Variable<String>(billToPhone.value);
    }
    if (billToGstin.present) {
      map['bill_to_gstin'] = Variable<String>(billToGstin.value);
    }
    if (discountPaise.present) {
      map['discount_paise'] = Variable<int>(discountPaise.value);
    }
    if (taxLabel.present) {
      map['tax_label'] = Variable<String>(taxLabel.value);
    }
    if (taxRateBp.present) {
      map['tax_rate_bp'] = Variable<int>(taxRateBp.value);
    }
    if (subtotalPaise.present) {
      map['subtotal_paise'] = Variable<int>(subtotalPaise.value);
    }
    if (taxPaise.present) {
      map['tax_paise'] = Variable<int>(taxPaise.value);
    }
    if (totalPaise.present) {
      map['total_paise'] = Variable<int>(totalPaise.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    if (cancelReason.present) {
      map['cancel_reason'] = Variable<String>(cancelReason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('invoiceNo: $invoiceNo, ')
          ..write('companyId: $companyId, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('billToName: $billToName, ')
          ..write('billToAddress: $billToAddress, ')
          ..write('billToPhone: $billToPhone, ')
          ..write('billToGstin: $billToGstin, ')
          ..write('discountPaise: $discountPaise, ')
          ..write('taxLabel: $taxLabel, ')
          ..write('taxRateBp: $taxRateBp, ')
          ..write('subtotalPaise: $subtotalPaise, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('notes: $notes, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('cancelReason: $cancelReason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTable extends InvoiceItems
    with TableInfo<$InvoiceItemsTable, InvoiceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMilliMeta = const VerificationMeta(
    'qtyMilli',
  );
  @override
  late final GeneratedColumn<int> qtyMilli = GeneratedColumn<int>(
    'qty_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1000),
  );
  static const VerificationMeta _unitPricePaiseMeta = const VerificationMeta(
    'unitPricePaise',
  );
  @override
  late final GeneratedColumn<int> unitPricePaise = GeneratedColumn<int>(
    'unit_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    invoiceId,
    visitId,
    kind,
    description,
    qtyMilli,
    unitPricePaise,
    amountPaise,
    sortOrder,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('qty_milli')) {
      context.handle(
        _qtyMilliMeta,
        qtyMilli.isAcceptableOrUnknown(data['qty_milli']!, _qtyMilliMeta),
      );
    }
    if (data.containsKey('unit_price_paise')) {
      context.handle(
        _unitPricePaiseMeta,
        unitPricePaise.isAcceptableOrUnknown(
          data['unit_price_paise']!,
          _unitPricePaiseMeta,
        ),
      );
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      qtyMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_milli'],
      )!,
      unitPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_paise'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $InvoiceItemsTable createAlias(String alias) {
    return $InvoiceItemsTable(attachedDatabase, alias);
  }
}

class InvoiceItem extends DataClass implements Insertable<InvoiceItem> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String invoiceId;
  final String? visitId;
  final String kind;
  final String description;
  final int qtyMilli;
  final int unitPricePaise;
  final int amountPaise;
  final int sortOrder;
  final DateTime? deletedAt;
  const InvoiceItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.invoiceId,
    this.visitId,
    required this.kind,
    required this.description,
    required this.qtyMilli,
    required this.unitPricePaise,
    required this.amountPaise,
    required this.sortOrder,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['invoice_id'] = Variable<String>(invoiceId);
    if (!nullToAbsent || visitId != null) {
      map['visit_id'] = Variable<String>(visitId);
    }
    map['kind'] = Variable<String>(kind);
    map['description'] = Variable<String>(description);
    map['qty_milli'] = Variable<int>(qtyMilli);
    map['unit_price_paise'] = Variable<int>(unitPricePaise);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  InvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      invoiceId: Value(invoiceId),
      visitId: visitId == null && nullToAbsent
          ? const Value.absent()
          : Value(visitId),
      kind: Value(kind),
      description: Value(description),
      qtyMilli: Value(qtyMilli),
      unitPricePaise: Value(unitPricePaise),
      amountPaise: Value(amountPaise),
      sortOrder: Value(sortOrder),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory InvoiceItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      visitId: serializer.fromJson<String?>(json['visitId']),
      kind: serializer.fromJson<String>(json['kind']),
      description: serializer.fromJson<String>(json['description']),
      qtyMilli: serializer.fromJson<int>(json['qtyMilli']),
      unitPricePaise: serializer.fromJson<int>(json['unitPricePaise']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'visitId': serializer.toJson<String?>(visitId),
      'kind': serializer.toJson<String>(kind),
      'description': serializer.toJson<String>(description),
      'qtyMilli': serializer.toJson<int>(qtyMilli),
      'unitPricePaise': serializer.toJson<int>(unitPricePaise),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  InvoiceItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? invoiceId,
    Value<String?> visitId = const Value.absent(),
    String? kind,
    String? description,
    int? qtyMilli,
    int? unitPricePaise,
    int? amountPaise,
    int? sortOrder,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => InvoiceItem(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    invoiceId: invoiceId ?? this.invoiceId,
    visitId: visitId.present ? visitId.value : this.visitId,
    kind: kind ?? this.kind,
    description: description ?? this.description,
    qtyMilli: qtyMilli ?? this.qtyMilli,
    unitPricePaise: unitPricePaise ?? this.unitPricePaise,
    amountPaise: amountPaise ?? this.amountPaise,
    sortOrder: sortOrder ?? this.sortOrder,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  InvoiceItem copyWithCompanion(InvoiceItemsCompanion data) {
    return InvoiceItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      kind: data.kind.present ? data.kind.value : this.kind,
      description: data.description.present
          ? data.description.value
          : this.description,
      qtyMilli: data.qtyMilli.present ? data.qtyMilli.value : this.qtyMilli,
      unitPricePaise: data.unitPricePaise.present
          ? data.unitPricePaise.value
          : this.unitPricePaise,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('visitId: $visitId, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('qtyMilli: $qtyMilli, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    invoiceId,
    visitId,
    kind,
    description,
    qtyMilli,
    unitPricePaise,
    amountPaise,
    sortOrder,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.invoiceId == this.invoiceId &&
          other.visitId == this.visitId &&
          other.kind == this.kind &&
          other.description == this.description &&
          other.qtyMilli == this.qtyMilli &&
          other.unitPricePaise == this.unitPricePaise &&
          other.amountPaise == this.amountPaise &&
          other.sortOrder == this.sortOrder &&
          other.deletedAt == this.deletedAt);
}

class InvoiceItemsCompanion extends UpdateCompanion<InvoiceItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> invoiceId;
  final Value<String?> visitId;
  final Value<String> kind;
  final Value<String> description;
  final Value<int> qtyMilli;
  final Value<int> unitPricePaise;
  final Value<int> amountPaise;
  final Value<int> sortOrder;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const InvoiceItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.visitId = const Value.absent(),
    this.kind = const Value.absent(),
    this.description = const Value.absent(),
    this.qtyMilli = const Value.absent(),
    this.unitPricePaise = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoiceItemsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String invoiceId,
    this.visitId = const Value.absent(),
    this.kind = const Value.absent(),
    required String description,
    this.qtyMilli = const Value.absent(),
    this.unitPricePaise = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       invoiceId = Value(invoiceId),
       description = Value(description);
  static Insertable<InvoiceItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? invoiceId,
    Expression<String>? visitId,
    Expression<String>? kind,
    Expression<String>? description,
    Expression<int>? qtyMilli,
    Expression<int>? unitPricePaise,
    Expression<int>? amountPaise,
    Expression<int>? sortOrder,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (visitId != null) 'visit_id': visitId,
      if (kind != null) 'kind': kind,
      if (description != null) 'description': description,
      if (qtyMilli != null) 'qty_milli': qtyMilli,
      if (unitPricePaise != null) 'unit_price_paise': unitPricePaise,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoiceItemsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? invoiceId,
    Value<String?>? visitId,
    Value<String>? kind,
    Value<String>? description,
    Value<int>? qtyMilli,
    Value<int>? unitPricePaise,
    Value<int>? amountPaise,
    Value<int>? sortOrder,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return InvoiceItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      invoiceId: invoiceId ?? this.invoiceId,
      visitId: visitId ?? this.visitId,
      kind: kind ?? this.kind,
      description: description ?? this.description,
      qtyMilli: qtyMilli ?? this.qtyMilli,
      unitPricePaise: unitPricePaise ?? this.unitPricePaise,
      amountPaise: amountPaise ?? this.amountPaise,
      sortOrder: sortOrder ?? this.sortOrder,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (qtyMilli.present) {
      map['qty_milli'] = Variable<int>(qtyMilli.value);
    }
    if (unitPricePaise.present) {
      map['unit_price_paise'] = Variable<int>(unitPricePaise.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('visitId: $visitId, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('qtyMilli: $qtyMilli, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receiptNoMeta = const VerificationMeta(
    'receiptNo',
  );
  @override
  late final GeneratedColumn<String> receiptNo = GeneratedColumn<String>(
    'receipt_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id)',
    ),
  );
  static const VerificationMeta _paidOnMeta = const VerificationMeta('paidOn');
  @override
  late final GeneratedColumn<String> paidOn = GeneratedColumn<String>(
    'paid_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cash'),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidedAtMeta = const VerificationMeta(
    'voidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> voidedAt = GeneratedColumn<DateTime>(
    'voided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidReasonMeta = const VerificationMeta(
    'voidReason',
  );
  @override
  late final GeneratedColumn<String> voidReason = GeneratedColumn<String>(
    'void_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    receiptNo,
    companyId,
    paidOn,
    amountPaise,
    method,
    reference,
    notes,
    voidedAt,
    voidReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('receipt_no')) {
      context.handle(
        _receiptNoMeta,
        receiptNo.isAcceptableOrUnknown(data['receipt_no']!, _receiptNoMeta),
      );
    } else if (isInserting) {
      context.missing(_receiptNoMeta);
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('paid_on')) {
      context.handle(
        _paidOnMeta,
        paidOn.isAcceptableOrUnknown(data['paid_on']!, _paidOnMeta),
      );
    } else if (isInserting) {
      context.missing(_paidOnMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('voided_at')) {
      context.handle(
        _voidedAtMeta,
        voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta),
      );
    }
    if (data.containsKey('void_reason')) {
      context.handle(
        _voidReasonMeta,
        voidReason.isAcceptableOrUnknown(data['void_reason']!, _voidReasonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      receiptNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_no'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      )!,
      paidOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_on'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      voidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}voided_at'],
      ),
      voidReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_reason'],
      ),
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String receiptNo;
  final String companyId;
  final String paidOn;
  final int amountPaise;
  final String method;
  final String? reference;
  final String? notes;
  final DateTime? voidedAt;
  final String? voidReason;
  const Payment({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.receiptNo,
    required this.companyId,
    required this.paidOn,
    required this.amountPaise,
    required this.method,
    this.reference,
    this.notes,
    this.voidedAt,
    this.voidReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['receipt_no'] = Variable<String>(receiptNo);
    map['company_id'] = Variable<String>(companyId);
    map['paid_on'] = Variable<String>(paidOn);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<DateTime>(voidedAt);
    }
    if (!nullToAbsent || voidReason != null) {
      map['void_reason'] = Variable<String>(voidReason);
    }
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      receiptNo: Value(receiptNo),
      companyId: Value(companyId),
      paidOn: Value(paidOn),
      amountPaise: Value(amountPaise),
      method: Value(method),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      voidedAt: voidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedAt),
      voidReason: voidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReason),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      receiptNo: serializer.fromJson<String>(json['receiptNo']),
      companyId: serializer.fromJson<String>(json['companyId']),
      paidOn: serializer.fromJson<String>(json['paidOn']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      method: serializer.fromJson<String>(json['method']),
      reference: serializer.fromJson<String?>(json['reference']),
      notes: serializer.fromJson<String?>(json['notes']),
      voidedAt: serializer.fromJson<DateTime?>(json['voidedAt']),
      voidReason: serializer.fromJson<String?>(json['voidReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'receiptNo': serializer.toJson<String>(receiptNo),
      'companyId': serializer.toJson<String>(companyId),
      'paidOn': serializer.toJson<String>(paidOn),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'method': serializer.toJson<String>(method),
      'reference': serializer.toJson<String?>(reference),
      'notes': serializer.toJson<String?>(notes),
      'voidedAt': serializer.toJson<DateTime?>(voidedAt),
      'voidReason': serializer.toJson<String?>(voidReason),
    };
  }

  Payment copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? receiptNo,
    String? companyId,
    String? paidOn,
    int? amountPaise,
    String? method,
    Value<String?> reference = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> voidedAt = const Value.absent(),
    Value<String?> voidReason = const Value.absent(),
  }) => Payment(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    receiptNo: receiptNo ?? this.receiptNo,
    companyId: companyId ?? this.companyId,
    paidOn: paidOn ?? this.paidOn,
    amountPaise: amountPaise ?? this.amountPaise,
    method: method ?? this.method,
    reference: reference.present ? reference.value : this.reference,
    notes: notes.present ? notes.value : this.notes,
    voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
    voidReason: voidReason.present ? voidReason.value : this.voidReason,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      receiptNo: data.receiptNo.present ? data.receiptNo.value : this.receiptNo,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      paidOn: data.paidOn.present ? data.paidOn.value : this.paidOn,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      method: data.method.present ? data.method.value : this.method,
      reference: data.reference.present ? data.reference.value : this.reference,
      notes: data.notes.present ? data.notes.value : this.notes,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      voidReason: data.voidReason.present
          ? data.voidReason.value
          : this.voidReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('receiptNo: $receiptNo, ')
          ..write('companyId: $companyId, ')
          ..write('paidOn: $paidOn, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('method: $method, ')
          ..write('reference: $reference, ')
          ..write('notes: $notes, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    receiptNo,
    companyId,
    paidOn,
    amountPaise,
    method,
    reference,
    notes,
    voidedAt,
    voidReason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.receiptNo == this.receiptNo &&
          other.companyId == this.companyId &&
          other.paidOn == this.paidOn &&
          other.amountPaise == this.amountPaise &&
          other.method == this.method &&
          other.reference == this.reference &&
          other.notes == this.notes &&
          other.voidedAt == this.voidedAt &&
          other.voidReason == this.voidReason);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> receiptNo;
  final Value<String> companyId;
  final Value<String> paidOn;
  final Value<int> amountPaise;
  final Value<String> method;
  final Value<String?> reference;
  final Value<String?> notes;
  final Value<DateTime?> voidedAt;
  final Value<String?> voidReason;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.receiptNo = const Value.absent(),
    this.companyId = const Value.absent(),
    this.paidOn = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.method = const Value.absent(),
    this.reference = const Value.absent(),
    this.notes = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String receiptNo,
    required String companyId,
    required String paidOn,
    required int amountPaise,
    this.method = const Value.absent(),
    this.reference = const Value.absent(),
    this.notes = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       receiptNo = Value(receiptNo),
       companyId = Value(companyId),
       paidOn = Value(paidOn),
       amountPaise = Value(amountPaise);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? receiptNo,
    Expression<String>? companyId,
    Expression<String>? paidOn,
    Expression<int>? amountPaise,
    Expression<String>? method,
    Expression<String>? reference,
    Expression<String>? notes,
    Expression<DateTime>? voidedAt,
    Expression<String>? voidReason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (receiptNo != null) 'receipt_no': receiptNo,
      if (companyId != null) 'company_id': companyId,
      if (paidOn != null) 'paid_on': paidOn,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (method != null) 'method': method,
      if (reference != null) 'reference': reference,
      if (notes != null) 'notes': notes,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (voidReason != null) 'void_reason': voidReason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? receiptNo,
    Value<String>? companyId,
    Value<String>? paidOn,
    Value<int>? amountPaise,
    Value<String>? method,
    Value<String?>? reference,
    Value<String?>? notes,
    Value<DateTime?>? voidedAt,
    Value<String?>? voidReason,
    Value<int>? rowid,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      receiptNo: receiptNo ?? this.receiptNo,
      companyId: companyId ?? this.companyId,
      paidOn: paidOn ?? this.paidOn,
      amountPaise: amountPaise ?? this.amountPaise,
      method: method ?? this.method,
      reference: reference ?? this.reference,
      notes: notes ?? this.notes,
      voidedAt: voidedAt ?? this.voidedAt,
      voidReason: voidReason ?? this.voidReason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (receiptNo.present) {
      map['receipt_no'] = Variable<String>(receiptNo.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (paidOn.present) {
      map['paid_on'] = Variable<String>(paidOn.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<DateTime>(voidedAt.value);
    }
    if (voidReason.present) {
      map['void_reason'] = Variable<String>(voidReason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('receiptNo: $receiptNo, ')
          ..write('companyId: $companyId, ')
          ..write('paidOn: $paidOn, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('method: $method, ')
          ..write('reference: $reference, ')
          ..write('notes: $notes, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentAllocationsTable extends PaymentAllocations
    with TableInfo<$PaymentAllocationsTable, PaymentAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentIdMeta = const VerificationMeta(
    'paymentId',
  );
  @override
  late final GeneratedColumn<String> paymentId = GeneratedColumn<String>(
    'payment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payments (id)',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    paymentId,
    invoiceId,
    amountPaise,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('payment_id')) {
      context.handle(
        _paymentIdMeta,
        paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_paymentIdMeta);
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      paymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PaymentAllocationsTable createAlias(String alias) {
    return $PaymentAllocationsTable(attachedDatabase, alias);
  }
}

class PaymentAllocation extends DataClass
    implements Insertable<PaymentAllocation> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String paymentId;
  final String invoiceId;
  final int amountPaise;
  final DateTime? deletedAt;
  const PaymentAllocation({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.paymentId,
    required this.invoiceId,
    required this.amountPaise,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['payment_id'] = Variable<String>(paymentId);
    map['invoice_id'] = Variable<String>(invoiceId);
    map['amount_paise'] = Variable<int>(amountPaise);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PaymentAllocationsCompanion toCompanion(bool nullToAbsent) {
    return PaymentAllocationsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      paymentId: Value(paymentId),
      invoiceId: Value(invoiceId),
      amountPaise: Value(amountPaise),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory PaymentAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentAllocation(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      paymentId: serializer.fromJson<String>(json['paymentId']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'paymentId': serializer.toJson<String>(paymentId),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  PaymentAllocation copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? paymentId,
    String? invoiceId,
    int? amountPaise,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => PaymentAllocation(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    paymentId: paymentId ?? this.paymentId,
    invoiceId: invoiceId ?? this.invoiceId,
    amountPaise: amountPaise ?? this.amountPaise,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  PaymentAllocation copyWithCompanion(PaymentAllocationsCompanion data) {
    return PaymentAllocation(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocation(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('paymentId: $paymentId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    paymentId,
    invoiceId,
    amountPaise,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentAllocation &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.paymentId == this.paymentId &&
          other.invoiceId == this.invoiceId &&
          other.amountPaise == this.amountPaise &&
          other.deletedAt == this.deletedAt);
}

class PaymentAllocationsCompanion extends UpdateCompanion<PaymentAllocation> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> paymentId;
  final Value<String> invoiceId;
  final Value<int> amountPaise;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PaymentAllocationsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentAllocationsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String paymentId,
    required String invoiceId,
    required int amountPaise,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       paymentId = Value(paymentId),
       invoiceId = Value(invoiceId),
       amountPaise = Value(amountPaise);
  static Insertable<PaymentAllocation> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? paymentId,
    Expression<String>? invoiceId,
    Expression<int>? amountPaise,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (paymentId != null) 'payment_id': paymentId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentAllocationsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? paymentId,
    Value<String>? invoiceId,
    Value<int>? amountPaise,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PaymentAllocationsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      paymentId: paymentId ?? this.paymentId,
      invoiceId: invoiceId ?? this.invoiceId,
      amountPaise: amountPaise ?? this.amountPaise,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<String>(paymentId.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('paymentId: $paymentId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('follow_up'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueTimeMeta = const VerificationMeta(
    'dueTime',
  );
  @override
  late final GeneratedColumn<String> dueTime = GeneratedColumn<String>(
    'due_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id)',
    ),
  );
  static const VerificationMeta _machineIdMeta = const VerificationMeta(
    'machineId',
  );
  @override
  late final GeneratedColumn<String> machineId = GeneratedColumn<String>(
    'machine_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES machines (id)',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    kind,
    title,
    notes,
    dueDate,
    dueTime,
    companyId,
    machineId,
    invoiceId,
    status,
    doneAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('due_time')) {
      context.handle(
        _dueTimeMeta,
        dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta),
      );
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    }
    if (data.containsKey('machine_id')) {
      context.handle(
        _machineIdMeta,
        machineId.isAcceptableOrUnknown(data['machine_id']!, _machineIdMeta),
      );
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      )!,
      dueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_time'],
      ),
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      ),
      machineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_id'],
      ),
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      ),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String kind;
  final String title;
  final String? notes;
  final String dueDate;
  final String? dueTime;
  final String? companyId;
  final String? machineId;
  final String? invoiceId;
  final String status;
  final DateTime? doneAt;
  const Reminder({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.kind,
    required this.title,
    this.notes,
    required this.dueDate,
    this.dueTime,
    this.companyId,
    this.machineId,
    this.invoiceId,
    required this.status,
    this.doneAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['due_date'] = Variable<String>(dueDate);
    if (!nullToAbsent || dueTime != null) {
      map['due_time'] = Variable<String>(dueTime);
    }
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<String>(companyId);
    }
    if (!nullToAbsent || machineId != null) {
      map['machine_id'] = Variable<String>(machineId);
    }
    if (!nullToAbsent || invoiceId != null) {
      map['invoice_id'] = Variable<String>(invoiceId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<DateTime>(doneAt);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      kind: Value(kind),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      dueDate: Value(dueDate),
      dueTime: dueTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTime),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
      machineId: machineId == null && nullToAbsent
          ? const Value.absent()
          : Value(machineId),
      invoiceId: invoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceId),
      status: Value(status),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      dueDate: serializer.fromJson<String>(json['dueDate']),
      dueTime: serializer.fromJson<String?>(json['dueTime']),
      companyId: serializer.fromJson<String?>(json['companyId']),
      machineId: serializer.fromJson<String?>(json['machineId']),
      invoiceId: serializer.fromJson<String?>(json['invoiceId']),
      status: serializer.fromJson<String>(json['status']),
      doneAt: serializer.fromJson<DateTime?>(json['doneAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'dueDate': serializer.toJson<String>(dueDate),
      'dueTime': serializer.toJson<String?>(dueTime),
      'companyId': serializer.toJson<String?>(companyId),
      'machineId': serializer.toJson<String?>(machineId),
      'invoiceId': serializer.toJson<String?>(invoiceId),
      'status': serializer.toJson<String>(status),
      'doneAt': serializer.toJson<DateTime?>(doneAt),
    };
  }

  Reminder copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? kind,
    String? title,
    Value<String?> notes = const Value.absent(),
    String? dueDate,
    Value<String?> dueTime = const Value.absent(),
    Value<String?> companyId = const Value.absent(),
    Value<String?> machineId = const Value.absent(),
    Value<String?> invoiceId = const Value.absent(),
    String? status,
    Value<DateTime?> doneAt = const Value.absent(),
  }) => Reminder(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    dueDate: dueDate ?? this.dueDate,
    dueTime: dueTime.present ? dueTime.value : this.dueTime,
    companyId: companyId.present ? companyId.value : this.companyId,
    machineId: machineId.present ? machineId.value : this.machineId,
    invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
    status: status ?? this.status,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      machineId: data.machineId.present ? data.machineId.value : this.machineId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      status: data.status.present ? data.status.value : this.status,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('companyId: $companyId, ')
          ..write('machineId: $machineId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('status: $status, ')
          ..write('doneAt: $doneAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    kind,
    title,
    notes,
    dueDate,
    dueTime,
    companyId,
    machineId,
    invoiceId,
    status,
    doneAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.dueDate == this.dueDate &&
          other.dueTime == this.dueTime &&
          other.companyId == this.companyId &&
          other.machineId == this.machineId &&
          other.invoiceId == this.invoiceId &&
          other.status == this.status &&
          other.doneAt == this.doneAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> kind;
  final Value<String> title;
  final Value<String?> notes;
  final Value<String> dueDate;
  final Value<String?> dueTime;
  final Value<String?> companyId;
  final Value<String?> machineId;
  final Value<String?> invoiceId;
  final Value<String> status;
  final Value<DateTime?> doneAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.companyId = const Value.absent(),
    this.machineId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.status = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    this.kind = const Value.absent(),
    required String title,
    this.notes = const Value.absent(),
    required String dueDate,
    this.dueTime = const Value.absent(),
    this.companyId = const Value.absent(),
    this.machineId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.status = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       title = Value(title),
       dueDate = Value(dueDate);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? dueDate,
    Expression<String>? dueTime,
    Expression<String>? companyId,
    Expression<String>? machineId,
    Expression<String>? invoiceId,
    Expression<String>? status,
    Expression<DateTime>? doneAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTime != null) 'due_time': dueTime,
      if (companyId != null) 'company_id': companyId,
      if (machineId != null) 'machine_id': machineId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (status != null) 'status': status,
      if (doneAt != null) 'done_at': doneAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? kind,
    Value<String>? title,
    Value<String?>? notes,
    Value<String>? dueDate,
    Value<String?>? dueTime,
    Value<String?>? companyId,
    Value<String?>? machineId,
    Value<String?>? invoiceId,
    Value<String>? status,
    Value<DateTime?>? doneAt,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      companyId: companyId ?? this.companyId,
      machineId: machineId ?? this.machineId,
      invoiceId: invoiceId ?? this.invoiceId,
      status: status ?? this.status,
      doneAt: doneAt ?? this.doneAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (dueTime.present) {
      map['due_time'] = Variable<String>(dueTime.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (machineId.present) {
      map['machine_id'] = Variable<String>(machineId.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('companyId: $companyId, ')
          ..write('machineId: $machineId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('status: $status, ')
          ..write('doneAt: $doneAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storagePathMeta = const VerificationMeta(
    'storagePath',
  );
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
    'storage_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    entityType,
    entityId,
    kind,
    fileName,
    mimeType,
    sizeBytes,
    caption,
    storagePath,
    localPath,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('storage_path')) {
      context.handle(
        _storagePathMeta,
        storagePath.isAcceptableOrUnknown(
          data['storage_path']!,
          _storagePathMeta,
        ),
      );
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      ),
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      storagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_path'],
      ),
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String entityType;
  final String entityId;
  final String kind;
  final String fileName;
  final String? mimeType;
  final int? sizeBytes;
  final String? caption;

  /// Path in Supabase Storage once uploaded (null = not yet uploaded).
  final String? storagePath;

  /// Device-specific file location. Local only, never synced.
  final String? localPath;
  final DateTime? deletedAt;
  const Attachment({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.entityType,
    required this.entityId,
    required this.kind,
    required this.fileName,
    this.mimeType,
    this.sizeBytes,
    this.caption,
    this.storagePath,
    this.localPath,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['kind'] = Variable<String>(kind);
    map['file_name'] = Variable<String>(fileName);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || sizeBytes != null) {
      map['size_bytes'] = Variable<int>(sizeBytes);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    if (!nullToAbsent || storagePath != null) {
      map['storage_path'] = Variable<String>(storagePath);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      entityType: Value(entityType),
      entityId: Value(entityId),
      kind: Value(kind),
      fileName: Value(fileName),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      sizeBytes: sizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeBytes),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      storagePath: storagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(storagePath),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Attachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      kind: serializer.fromJson<String>(json['kind']),
      fileName: serializer.fromJson<String>(json['fileName']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      sizeBytes: serializer.fromJson<int?>(json['sizeBytes']),
      caption: serializer.fromJson<String?>(json['caption']),
      storagePath: serializer.fromJson<String?>(json['storagePath']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'kind': serializer.toJson<String>(kind),
      'fileName': serializer.toJson<String>(fileName),
      'mimeType': serializer.toJson<String?>(mimeType),
      'sizeBytes': serializer.toJson<int?>(sizeBytes),
      'caption': serializer.toJson<String?>(caption),
      'storagePath': serializer.toJson<String?>(storagePath),
      'localPath': serializer.toJson<String?>(localPath),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Attachment copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? entityType,
    String? entityId,
    String? kind,
    String? fileName,
    Value<String?> mimeType = const Value.absent(),
    Value<int?> sizeBytes = const Value.absent(),
    Value<String?> caption = const Value.absent(),
    Value<String?> storagePath = const Value.absent(),
    Value<String?> localPath = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Attachment(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    kind: kind ?? this.kind,
    fileName: fileName ?? this.fileName,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    sizeBytes: sizeBytes.present ? sizeBytes.value : this.sizeBytes,
    caption: caption.present ? caption.value : this.caption,
    storagePath: storagePath.present ? storagePath.value : this.storagePath,
    localPath: localPath.present ? localPath.value : this.localPath,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      kind: data.kind.present ? data.kind.value : this.kind,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      caption: data.caption.present ? data.caption.value : this.caption,
      storagePath: data.storagePath.present
          ? data.storagePath.value
          : this.storagePath,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('kind: $kind, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('caption: $caption, ')
          ..write('storagePath: $storagePath, ')
          ..write('localPath: $localPath, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    entityType,
    entityId,
    kind,
    fileName,
    mimeType,
    sizeBytes,
    caption,
    storagePath,
    localPath,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.kind == this.kind &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.caption == this.caption &&
          other.storagePath == this.storagePath &&
          other.localPath == this.localPath &&
          other.deletedAt == this.deletedAt);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> kind;
  final Value<String> fileName;
  final Value<String?> mimeType;
  final Value<int?> sizeBytes;
  final Value<String?> caption;
  final Value<String?> storagePath;
  final Value<String?> localPath;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.kind = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.caption = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.localPath = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String entityType,
    required String entityId,
    required String kind,
    required String fileName,
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.caption = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.localPath = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       entityType = Value(entityType),
       entityId = Value(entityId),
       kind = Value(kind),
       fileName = Value(fileName);
  static Insertable<Attachment> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? kind,
    Expression<String>? fileName,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<String>? caption,
    Expression<String>? storagePath,
    Expression<String>? localPath,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (kind != null) 'kind': kind,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (caption != null) 'caption': caption,
      if (storagePath != null) 'storage_path': storagePath,
      if (localPath != null) 'local_path': localPath,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? kind,
    Value<String>? fileName,
    Value<String?>? mimeType,
    Value<int?>? sizeBytes,
    Value<String?>? caption,
    Value<String?>? storagePath,
    Value<String?>? localPath,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      kind: kind ?? this.kind,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      caption: caption ?? this.caption,
      storagePath: storagePath ?? this.storagePath,
      localPath: localPath ?? this.localPath,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('kind: $kind, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('caption: $caption, ')
          ..write('storagePath: $storagePath, ')
          ..write('localPath: $localPath, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changesMeta = const VerificationMeta(
    'changes',
  );
  @override
  late final GeneratedColumn<String> changes = GeneratedColumn<String>(
    'changes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    serverRev,
    entityType,
    entityId,
    action,
    summary,
    changes,
    actor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('changes')) {
      context.handle(
        _changesMeta,
        changes.isAcceptableOrUnknown(data['changes']!, _changesMeta),
      );
    }
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      changes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changes'],
      ),
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      ),
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditEntry extends DataClass implements Insertable<AuditEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverRev;
  final String entityType;
  final String entityId;
  final String action;
  final String? summary;

  /// JSON object: {"field": {"from": .., "to": ..}}
  final String? changes;
  final String? actor;
  const AuditEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.serverRev,
    required this.entityType,
    required this.entityId,
    required this.action,
    this.summary,
    this.changes,
    this.actor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_rev'] = Variable<int>(serverRev);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || changes != null) {
      map['changes'] = Variable<String>(changes);
    }
    if (!nullToAbsent || actor != null) {
      map['actor'] = Variable<String>(actor);
    }
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverRev: Value(serverRev),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      changes: changes == null && nullToAbsent
          ? const Value.absent()
          : Value(changes),
      actor: actor == null && nullToAbsent
          ? const Value.absent()
          : Value(actor),
    );
  }

  factory AuditEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverRev: serializer.fromJson<int>(json['serverRev']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      summary: serializer.fromJson<String?>(json['summary']),
      changes: serializer.fromJson<String?>(json['changes']),
      actor: serializer.fromJson<String?>(json['actor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverRev': serializer.toJson<int>(serverRev),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'summary': serializer.toJson<String?>(summary),
      'changes': serializer.toJson<String?>(changes),
      'actor': serializer.toJson<String?>(actor),
    };
  }

  AuditEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? serverRev,
    String? entityType,
    String? entityId,
    String? action,
    Value<String?> summary = const Value.absent(),
    Value<String?> changes = const Value.absent(),
    Value<String?> actor = const Value.absent(),
  }) => AuditEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverRev: serverRev ?? this.serverRev,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    action: action ?? this.action,
    summary: summary.present ? summary.value : this.summary,
    changes: changes.present ? changes.value : this.changes,
    actor: actor.present ? actor.value : this.actor,
  );
  AuditEntry copyWithCompanion(AuditLogCompanion data) {
    return AuditEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      summary: data.summary.present ? data.summary.value : this.summary,
      changes: data.changes.present ? data.changes.value : this.changes,
      actor: data.actor.present ? data.actor.value : this.actor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('summary: $summary, ')
          ..write('changes: $changes, ')
          ..write('actor: $actor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    serverRev,
    entityType,
    entityId,
    action,
    summary,
    changes,
    actor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverRev == this.serverRev &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.summary == this.summary &&
          other.changes == this.changes &&
          other.actor == this.actor);
}

class AuditLogCompanion extends UpdateCompanion<AuditEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverRev;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<String?> summary;
  final Value<String?> changes;
  final Value<String?> actor;
  final Value<int> rowid;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.summary = const Value.absent(),
    this.changes = const Value.absent(),
    this.actor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverRev = const Value.absent(),
    required String entityType,
    required String entityId,
    required String action,
    this.summary = const Value.absent(),
    this.changes = const Value.absent(),
    this.actor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       entityType = Value(entityType),
       entityId = Value(entityId),
       action = Value(action);
  static Insertable<AuditEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverRev,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String>? summary,
    Expression<String>? changes,
    Expression<String>? actor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverRev != null) 'server_rev': serverRev,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (summary != null) 'summary': summary,
      if (changes != null) 'changes': changes,
      if (actor != null) 'actor': actor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? serverRev,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? action,
    Value<String?>? summary,
    Value<String?>? changes,
    Value<String?>? actor,
    Value<int>? rowid,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverRev: serverRev ?? this.serverRev,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      summary: summary ?? this.summary,
      changes: changes ?? this.changes,
      actor: actor ?? this.actor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (changes.present) {
      map['changes'] = Variable<String>(changes.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverRev: $serverRev, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('summary: $summary, ')
          ..write('changes: $changes, ')
          ..write('actor: $actor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tableName_Meta = const VerificationMeta(
    'tableName_',
  );
  @override
  late final GeneratedColumn<String> tableName_ = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opIdMeta = const VerificationMeta('opId');
  @override
  late final GeneratedColumn<String> opId = GeneratedColumn<String>(
    'op_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _queuedAtMeta = const VerificationMeta(
    'queuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> queuedAt = GeneratedColumn<DateTime>(
    'queued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    tableName_,
    rowId,
    opId,
    queuedAt,
    attempts,
    lastError,
    nextAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('table_name')) {
      context.handle(
        _tableName_Meta,
        tableName_.isAcceptableOrUnknown(data['table_name']!, _tableName_Meta),
      );
    } else if (isInserting) {
      context.missing(_tableName_Meta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('op_id')) {
      context.handle(
        _opIdMeta,
        opId.isAcceptableOrUnknown(data['op_id']!, _opIdMeta),
      );
    } else if (isInserting) {
      context.missing(_opIdMeta);
    }
    if (data.containsKey('queued_at')) {
      context.handle(
        _queuedAtMeta,
        queuedAt.isAcceptableOrUnknown(data['queued_at']!, _queuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_queuedAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tableName_, rowId};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      tableName_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      opId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_id'],
      )!,
      queuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}queued_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final String tableName_;
  final String rowId;
  final String opId;
  final DateTime queuedAt;
  final int attempts;
  final String? lastError;
  final DateTime? nextAttemptAt;
  const OutboxEntry({
    required this.tableName_,
    required this.rowId,
    required this.opId,
    required this.queuedAt,
    required this.attempts,
    this.lastError,
    this.nextAttemptAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['table_name'] = Variable<String>(tableName_);
    map['row_id'] = Variable<String>(rowId);
    map['op_id'] = Variable<String>(opId);
    map['queued_at'] = Variable<DateTime>(queuedAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      tableName_: Value(tableName_),
      rowId: Value(rowId),
      opId: Value(opId),
      queuedAt: Value(queuedAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      tableName_: serializer.fromJson<String>(json['tableName_']),
      rowId: serializer.fromJson<String>(json['rowId']),
      opId: serializer.fromJson<String>(json['opId']),
      queuedAt: serializer.fromJson<DateTime>(json['queuedAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tableName_': serializer.toJson<String>(tableName_),
      'rowId': serializer.toJson<String>(rowId),
      'opId': serializer.toJson<String>(opId),
      'queuedAt': serializer.toJson<DateTime>(queuedAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
    };
  }

  OutboxEntry copyWith({
    String? tableName_,
    String? rowId,
    String? opId,
    DateTime? queuedAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> nextAttemptAt = const Value.absent(),
  }) => OutboxEntry(
    tableName_: tableName_ ?? this.tableName_,
    rowId: rowId ?? this.rowId,
    opId: opId ?? this.opId,
    queuedAt: queuedAt ?? this.queuedAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
  );
  OutboxEntry copyWithCompanion(SyncOutboxCompanion data) {
    return OutboxEntry(
      tableName_: data.tableName_.present
          ? data.tableName_.value
          : this.tableName_,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      opId: data.opId.present ? data.opId.value : this.opId,
      queuedAt: data.queuedAt.present ? data.queuedAt.value : this.queuedAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('tableName_: $tableName_, ')
          ..write('rowId: $rowId, ')
          ..write('opId: $opId, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('nextAttemptAt: $nextAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tableName_,
    rowId,
    opId,
    queuedAt,
    attempts,
    lastError,
    nextAttemptAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.tableName_ == this.tableName_ &&
          other.rowId == this.rowId &&
          other.opId == this.opId &&
          other.queuedAt == this.queuedAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.nextAttemptAt == this.nextAttemptAt);
}

class SyncOutboxCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<String> tableName_;
  final Value<String> rowId;
  final Value<String> opId;
  final Value<DateTime> queuedAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime?> nextAttemptAt;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.tableName_ = const Value.absent(),
    this.rowId = const Value.absent(),
    this.opId = const Value.absent(),
    this.queuedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String tableName_,
    required String rowId,
    required String opId,
    required DateTime queuedAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tableName_ = Value(tableName_),
       rowId = Value(rowId),
       opId = Value(opId),
       queuedAt = Value(queuedAt);
  static Insertable<OutboxEntry> custom({
    Expression<String>? tableName_,
    Expression<String>? rowId,
    Expression<String>? opId,
    Expression<DateTime>? queuedAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? nextAttemptAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tableName_ != null) 'table_name': tableName_,
      if (rowId != null) 'row_id': rowId,
      if (opId != null) 'op_id': opId,
      if (queuedAt != null) 'queued_at': queuedAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? tableName_,
    Value<String>? rowId,
    Value<String>? opId,
    Value<DateTime>? queuedAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<DateTime?>? nextAttemptAt,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      tableName_: tableName_ ?? this.tableName_,
      rowId: rowId ?? this.rowId,
      opId: opId ?? this.opId,
      queuedAt: queuedAt ?? this.queuedAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tableName_.present) {
      map['table_name'] = Variable<String>(tableName_.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (opId.present) {
      map['op_id'] = Variable<String>(opId.value);
    }
    if (queuedAt.present) {
      map['queued_at'] = Variable<DateTime>(queuedAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('tableName_: $tableName_, ')
          ..write('rowId: $rowId, ')
          ..write('opId: $opId, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncConflictsTable extends SyncConflicts
    with TableInfo<$SyncConflictsTable, SyncConflict> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncConflictsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableName_Meta = const VerificationMeta(
    'tableName_',
  );
  @override
  late final GeneratedColumn<String> tableName_ = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDataMeta = const VerificationMeta(
    'localData',
  );
  @override
  late final GeneratedColumn<String> localData = GeneratedColumn<String>(
    'local_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverDataMeta = const VerificationMeta(
    'serverData',
  );
  @override
  late final GeneratedColumn<String> serverData = GeneratedColumn<String>(
    'server_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detectedAtMeta = const VerificationMeta(
    'detectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
    'detected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tableName_,
    rowId,
    localData,
    serverData,
    detectedAt,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_conflicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncConflict> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _tableName_Meta,
        tableName_.isAcceptableOrUnknown(data['table_name']!, _tableName_Meta),
      );
    } else if (isInserting) {
      context.missing(_tableName_Meta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('local_data')) {
      context.handle(
        _localDataMeta,
        localData.isAcceptableOrUnknown(data['local_data']!, _localDataMeta),
      );
    } else if (isInserting) {
      context.missing(_localDataMeta);
    }
    if (data.containsKey('server_data')) {
      context.handle(
        _serverDataMeta,
        serverData.isAcceptableOrUnknown(data['server_data']!, _serverDataMeta),
      );
    } else if (isInserting) {
      context.missing(_serverDataMeta);
    }
    if (data.containsKey('detected_at')) {
      context.handle(
        _detectedAtMeta,
        detectedAt.isAcceptableOrUnknown(data['detected_at']!, _detectedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_detectedAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncConflict map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncConflict(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tableName_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      localData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_data'],
      )!,
      serverData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_data'],
      )!,
      detectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}detected_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
    );
  }

  @override
  $SyncConflictsTable createAlias(String alias) {
    return $SyncConflictsTable(attachedDatabase, alias);
  }
}

class SyncConflict extends DataClass implements Insertable<SyncConflict> {
  final String id;
  final String tableName_;
  final String rowId;
  final String localData;
  final String serverData;
  final DateTime detectedAt;
  final DateTime? resolvedAt;
  const SyncConflict({
    required this.id,
    required this.tableName_,
    required this.rowId,
    required this.localData,
    required this.serverData,
    required this.detectedAt,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['table_name'] = Variable<String>(tableName_);
    map['row_id'] = Variable<String>(rowId);
    map['local_data'] = Variable<String>(localData);
    map['server_data'] = Variable<String>(serverData);
    map['detected_at'] = Variable<DateTime>(detectedAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  SyncConflictsCompanion toCompanion(bool nullToAbsent) {
    return SyncConflictsCompanion(
      id: Value(id),
      tableName_: Value(tableName_),
      rowId: Value(rowId),
      localData: Value(localData),
      serverData: Value(serverData),
      detectedAt: Value(detectedAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory SyncConflict.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncConflict(
      id: serializer.fromJson<String>(json['id']),
      tableName_: serializer.fromJson<String>(json['tableName_']),
      rowId: serializer.fromJson<String>(json['rowId']),
      localData: serializer.fromJson<String>(json['localData']),
      serverData: serializer.fromJson<String>(json['serverData']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tableName_': serializer.toJson<String>(tableName_),
      'rowId': serializer.toJson<String>(rowId),
      'localData': serializer.toJson<String>(localData),
      'serverData': serializer.toJson<String>(serverData),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  SyncConflict copyWith({
    String? id,
    String? tableName_,
    String? rowId,
    String? localData,
    String? serverData,
    DateTime? detectedAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
  }) => SyncConflict(
    id: id ?? this.id,
    tableName_: tableName_ ?? this.tableName_,
    rowId: rowId ?? this.rowId,
    localData: localData ?? this.localData,
    serverData: serverData ?? this.serverData,
    detectedAt: detectedAt ?? this.detectedAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  SyncConflict copyWithCompanion(SyncConflictsCompanion data) {
    return SyncConflict(
      id: data.id.present ? data.id.value : this.id,
      tableName_: data.tableName_.present
          ? data.tableName_.value
          : this.tableName_,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      localData: data.localData.present ? data.localData.value : this.localData,
      serverData: data.serverData.present
          ? data.serverData.value
          : this.serverData,
      detectedAt: data.detectedAt.present
          ? data.detectedAt.value
          : this.detectedAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflict(')
          ..write('id: $id, ')
          ..write('tableName_: $tableName_, ')
          ..write('rowId: $rowId, ')
          ..write('localData: $localData, ')
          ..write('serverData: $serverData, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tableName_,
    rowId,
    localData,
    serverData,
    detectedAt,
    resolvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncConflict &&
          other.id == this.id &&
          other.tableName_ == this.tableName_ &&
          other.rowId == this.rowId &&
          other.localData == this.localData &&
          other.serverData == this.serverData &&
          other.detectedAt == this.detectedAt &&
          other.resolvedAt == this.resolvedAt);
}

class SyncConflictsCompanion extends UpdateCompanion<SyncConflict> {
  final Value<String> id;
  final Value<String> tableName_;
  final Value<String> rowId;
  final Value<String> localData;
  final Value<String> serverData;
  final Value<DateTime> detectedAt;
  final Value<DateTime?> resolvedAt;
  final Value<int> rowid;
  const SyncConflictsCompanion({
    this.id = const Value.absent(),
    this.tableName_ = const Value.absent(),
    this.rowId = const Value.absent(),
    this.localData = const Value.absent(),
    this.serverData = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncConflictsCompanion.insert({
    required String id,
    required String tableName_,
    required String rowId,
    required String localData,
    required String serverData,
    required DateTime detectedAt,
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tableName_ = Value(tableName_),
       rowId = Value(rowId),
       localData = Value(localData),
       serverData = Value(serverData),
       detectedAt = Value(detectedAt);
  static Insertable<SyncConflict> custom({
    Expression<String>? id,
    Expression<String>? tableName_,
    Expression<String>? rowId,
    Expression<String>? localData,
    Expression<String>? serverData,
    Expression<DateTime>? detectedAt,
    Expression<DateTime>? resolvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableName_ != null) 'table_name': tableName_,
      if (rowId != null) 'row_id': rowId,
      if (localData != null) 'local_data': localData,
      if (serverData != null) 'server_data': serverData,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncConflictsCompanion copyWith({
    Value<String>? id,
    Value<String>? tableName_,
    Value<String>? rowId,
    Value<String>? localData,
    Value<String>? serverData,
    Value<DateTime>? detectedAt,
    Value<DateTime?>? resolvedAt,
    Value<int>? rowid,
  }) {
    return SyncConflictsCompanion(
      id: id ?? this.id,
      tableName_: tableName_ ?? this.tableName_,
      rowId: rowId ?? this.rowId,
      localData: localData ?? this.localData,
      serverData: serverData ?? this.serverData,
      detectedAt: detectedAt ?? this.detectedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tableName_.present) {
      map['table_name'] = Variable<String>(tableName_.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (localData.present) {
      map['local_data'] = Variable<String>(localData.value);
    }
    if (serverData.present) {
      map['server_data'] = Variable<String>(serverData.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictsCompanion(')
          ..write('id: $id, ')
          ..write('tableName_: $tableName_, ')
          ..write('rowId: $rowId, ')
          ..write('localData: $localData, ')
          ..write('serverData: $serverData, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CompaniesTable companies = $CompaniesTable(this);
  late final $MachinesTable machines = $MachinesTable(this);
  late final $PartsTable parts = $PartsTable(this);
  late final $ServiceVisitsTable serviceVisits = $ServiceVisitsTable(this);
  late final $VisitPartsTable visitParts = $VisitPartsTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceItemsTable invoiceItems = $InvoiceItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $PaymentAllocationsTable paymentAllocations =
      $PaymentAllocationsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $SyncConflictsTable syncConflicts = $SyncConflictsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final Index idxCompaniesName = Index(
    'idx_companies_name',
    'CREATE INDEX idx_companies_name ON companies (name)',
  );
  late final Index idxMachinesCompany = Index(
    'idx_machines_company',
    'CREATE INDEX idx_machines_company ON machines (company_id)',
  );
  late final Index idxPartsName = Index(
    'idx_parts_name',
    'CREATE INDEX idx_parts_name ON parts (name)',
  );
  late final Index idxVisitsCompany = Index(
    'idx_visits_company',
    'CREATE INDEX idx_visits_company ON service_visits (company_id)',
  );
  late final Index idxVisitsMachine = Index(
    'idx_visits_machine',
    'CREATE INDEX idx_visits_machine ON service_visits (machine_id)',
  );
  late final Index idxVisitsDate = Index(
    'idx_visits_date',
    'CREATE INDEX idx_visits_date ON service_visits (visit_date)',
  );
  late final Index idxVisitPartsVisit = Index(
    'idx_visit_parts_visit',
    'CREATE INDEX idx_visit_parts_visit ON visit_parts (visit_id)',
  );
  late final Index idxVisitPartsPart = Index(
    'idx_visit_parts_part',
    'CREATE INDEX idx_visit_parts_part ON visit_parts (part_id)',
  );
  late final Index idxMovementsPart = Index(
    'idx_movements_part',
    'CREATE INDEX idx_movements_part ON stock_movements (part_id)',
  );
  late final Index idxInvoicesCompany = Index(
    'idx_invoices_company',
    'CREATE INDEX idx_invoices_company ON invoices (company_id)',
  );
  late final Index idxInvoiceItemsInvoice = Index(
    'idx_invoice_items_invoice',
    'CREATE INDEX idx_invoice_items_invoice ON invoice_items (invoice_id)',
  );
  late final Index idxPaymentsCompany = Index(
    'idx_payments_company',
    'CREATE INDEX idx_payments_company ON payments (company_id)',
  );
  late final Index idxAllocationsInvoice = Index(
    'idx_allocations_invoice',
    'CREATE INDEX idx_allocations_invoice ON payment_allocations (invoice_id)',
  );
  late final Index idxAllocationsPayment = Index(
    'idx_allocations_payment',
    'CREATE INDEX idx_allocations_payment ON payment_allocations (payment_id)',
  );
  late final Index idxAttachmentsEntity = Index(
    'idx_attachments_entity',
    'CREATE INDEX idx_attachments_entity ON attachments (entity_type, entity_id)',
  );
  late final Index idxAuditEntity = Index(
    'idx_audit_entity',
    'CREATE INDEX idx_audit_entity ON audit_log (entity_type, entity_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    companies,
    machines,
    parts,
    serviceVisits,
    visitParts,
    stockMovements,
    invoices,
    invoiceItems,
    payments,
    paymentAllocations,
    reminders,
    attachments,
    auditLog,
    syncOutbox,
    syncConflicts,
    appSettings,
    idxCompaniesName,
    idxMachinesCompany,
    idxPartsName,
    idxVisitsCompany,
    idxVisitsMachine,
    idxVisitsDate,
    idxVisitPartsVisit,
    idxVisitPartsPart,
    idxMovementsPart,
    idxInvoicesCompany,
    idxInvoiceItemsInvoice,
    idxPaymentsCompany,
    idxAllocationsInvoice,
    idxAllocationsPayment,
    idxAttachmentsEntity,
    idxAuditEntity,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$CompaniesTableCreateCompanionBuilder =
    CompaniesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      Value<String?> code,
      required String name,
      Value<String?> contactPerson,
      Value<String?> phone,
      Value<String?> altPhone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> city,
      Value<String?> state,
      Value<String?> pincode,
      Value<String?> gstin,
      Value<String?> notes,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$CompaniesTableUpdateCompanionBuilder =
    CompaniesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String?> code,
      Value<String> name,
      Value<String?> contactPerson,
      Value<String?> phone,
      Value<String?> altPhone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> city,
      Value<String?> state,
      Value<String?> pincode,
      Value<String?> gstin,
      Value<String?> notes,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$CompaniesTableReferences
    extends BaseReferences<_$AppDatabase, $CompaniesTable, Company> {
  $$CompaniesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MachinesTable, List<Machine>> _machinesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.machines,
    aliasName: 'companies__id__machines__company_id',
  );

  $$MachinesTableProcessedTableManager get machinesRefs {
    final manager = $$MachinesTableTableManager(
      $_db,
      $_db.machines,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_machinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ServiceVisitsTable, List<ServiceVisit>>
  _serviceVisitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serviceVisits,
    aliasName: 'companies__id__service_visits__company_id',
  );

  $$ServiceVisitsTableProcessedTableManager get serviceVisitsRefs {
    final manager = $$ServiceVisitsTableTableManager(
      $_db,
      $_db.serviceVisits,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceVisitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: 'companies__id__invoices__company_id',
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: 'companies__id__payments__company_id',
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'companies__id__reminders__company_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get altPhone => $composableBuilder(
    column: $table.altPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> machinesRefs(
    Expression<bool> Function($$MachinesTableFilterComposer f) f,
  ) {
    final $$MachinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.machines,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MachinesTableFilterComposer(
            $db: $db,
            $table: $db.machines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> serviceVisitsRefs(
    Expression<bool> Function($$ServiceVisitsTableFilterComposer f) f,
  ) {
    final $$ServiceVisitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceVisits,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceVisitsTableFilterComposer(
            $db: $db,
            $table: $db.serviceVisits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get altPhone => $composableBuilder(
    column: $table.altPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get altPhone =>
      $composableBuilder(column: $table.altPhone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get pincode =>
      $composableBuilder(column: $table.pincode, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> machinesRefs<T extends Object>(
    Expression<T> Function($$MachinesTableAnnotationComposer a) f,
  ) {
    final $$MachinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.machines,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MachinesTableAnnotationComposer(
            $db: $db,
            $table: $db.machines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> serviceVisitsRefs<T extends Object>(
    Expression<T> Function($$ServiceVisitsTableAnnotationComposer a) f,
  ) {
    final $$ServiceVisitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceVisits,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceVisitsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceVisits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompaniesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompaniesTable,
          Company,
          $$CompaniesTableFilterComposer,
          $$CompaniesTableOrderingComposer,
          $$CompaniesTableAnnotationComposer,
          $$CompaniesTableCreateCompanionBuilder,
          $$CompaniesTableUpdateCompanionBuilder,
          (Company, $$CompaniesTableReferences),
          Company,
          PrefetchHooks Function({
            bool machinesRefs,
            bool serviceVisitsRefs,
            bool invoicesRefs,
            bool paymentsRefs,
            bool remindersRefs,
          })
        > {
  $$CompaniesTableTableManager(_$AppDatabase db, $CompaniesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompaniesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompaniesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> altPhone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompaniesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                code: code,
                name: name,
                contactPerson: contactPerson,
                phone: phone,
                altPhone: altPhone,
                email: email,
                address: address,
                city: city,
                state: state,
                pincode: pincode,
                gstin: gstin,
                notes: notes,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                Value<String?> code = const Value.absent(),
                required String name,
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> altPhone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompaniesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                code: code,
                name: name,
                contactPerson: contactPerson,
                phone: phone,
                altPhone: altPhone,
                email: email,
                address: address,
                city: city,
                state: state,
                pincode: pincode,
                gstin: gstin,
                notes: notes,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompaniesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                machinesRefs = false,
                serviceVisitsRefs = false,
                invoicesRefs = false,
                paymentsRefs = false,
                remindersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (machinesRefs) db.machines,
                    if (serviceVisitsRefs) db.serviceVisits,
                    if (invoicesRefs) db.invoices,
                    if (paymentsRefs) db.payments,
                    if (remindersRefs) db.reminders,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (machinesRefs)
                        await $_getPrefetchedData<
                          Company,
                          $CompaniesTable,
                          Machine
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._machinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).machinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.companyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (serviceVisitsRefs)
                        await $_getPrefetchedData<
                          Company,
                          $CompaniesTable,
                          ServiceVisit
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._serviceVisitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).serviceVisitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.companyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoicesRefs)
                        await $_getPrefetchedData<
                          Company,
                          $CompaniesTable,
                          Invoice
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.companyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          Company,
                          $CompaniesTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.companyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          Company,
                          $CompaniesTable,
                          Reminder
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.companyId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CompaniesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompaniesTable,
      Company,
      $$CompaniesTableFilterComposer,
      $$CompaniesTableOrderingComposer,
      $$CompaniesTableAnnotationComposer,
      $$CompaniesTableCreateCompanionBuilder,
      $$CompaniesTableUpdateCompanionBuilder,
      (Company, $$CompaniesTableReferences),
      Company,
      PrefetchHooks Function({
        bool machinesRefs,
        bool serviceVisitsRefs,
        bool invoicesRefs,
        bool paymentsRefs,
        bool remindersRefs,
      })
    >;
typedef $$MachinesTableCreateCompanionBuilder =
    MachinesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String companyId,
      required String name,
      Value<String> category,
      Value<String?> manufacturer,
      Value<String?> model,
      Value<String?> serialNumber,
      Value<String?> location,
      Value<String?> installedOn,
      Value<String?> warrantyUntil,
      Value<int?> serviceIntervalDays,
      Value<String?> nextServiceDue,
      Value<String> status,
      Value<String?> notes,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$MachinesTableUpdateCompanionBuilder =
    MachinesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> companyId,
      Value<String> name,
      Value<String> category,
      Value<String?> manufacturer,
      Value<String?> model,
      Value<String?> serialNumber,
      Value<String?> location,
      Value<String?> installedOn,
      Value<String?> warrantyUntil,
      Value<int?> serviceIntervalDays,
      Value<String?> nextServiceDue,
      Value<String> status,
      Value<String?> notes,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$MachinesTableReferences
    extends BaseReferences<_$AppDatabase, $MachinesTable, Machine> {
  $$MachinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('machines__company_id__companies__id');

  $$CompaniesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<String>('company_id')!;

    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ServiceVisitsTable, List<ServiceVisit>>
  _serviceVisitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serviceVisits,
    aliasName: 'machines__id__service_visits__machine_id',
  );

  $$ServiceVisitsTableProcessedTableManager get serviceVisitsRefs {
    final manager = $$ServiceVisitsTableTableManager(
      $_db,
      $_db.serviceVisits,
    ).filter((f) => f.machineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceVisitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'machines__id__reminders__machine_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.machineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MachinesTableFilterComposer
    extends Composer<_$AppDatabase, $MachinesTable> {
  $$MachinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get installedOn => $composableBuilder(
    column: $table.installedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get warrantyUntil => $composableBuilder(
    column: $table.warrantyUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serviceIntervalDays => $composableBuilder(
    column: $table.serviceIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextServiceDue => $composableBuilder(
    column: $table.nextServiceDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> serviceVisitsRefs(
    Expression<bool> Function($$ServiceVisitsTableFilterComposer f) f,
  ) {
    final $$ServiceVisitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceVisits,
      getReferencedColumn: (t) => t.machineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceVisitsTableFilterComposer(
            $db: $db,
            $table: $db.serviceVisits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.machineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MachinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MachinesTable> {
  $$MachinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get installedOn => $composableBuilder(
    column: $table.installedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warrantyUntil => $composableBuilder(
    column: $table.warrantyUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serviceIntervalDays => $composableBuilder(
    column: $table.serviceIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextServiceDue => $composableBuilder(
    column: $table.nextServiceDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MachinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MachinesTable> {
  $$MachinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get installedOn => $composableBuilder(
    column: $table.installedOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get warrantyUntil => $composableBuilder(
    column: $table.warrantyUntil,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serviceIntervalDays => $composableBuilder(
    column: $table.serviceIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nextServiceDue => $composableBuilder(
    column: $table.nextServiceDue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> serviceVisitsRefs<T extends Object>(
    Expression<T> Function($$ServiceVisitsTableAnnotationComposer a) f,
  ) {
    final $$ServiceVisitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceVisits,
      getReferencedColumn: (t) => t.machineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceVisitsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceVisits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.machineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MachinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MachinesTable,
          Machine,
          $$MachinesTableFilterComposer,
          $$MachinesTableOrderingComposer,
          $$MachinesTableAnnotationComposer,
          $$MachinesTableCreateCompanionBuilder,
          $$MachinesTableUpdateCompanionBuilder,
          (Machine, $$MachinesTableReferences),
          Machine,
          PrefetchHooks Function({
            bool companyId,
            bool serviceVisitsRefs,
            bool remindersRefs,
          })
        > {
  $$MachinesTableTableManager(_$AppDatabase db, $MachinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MachinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MachinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MachinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> serialNumber = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> installedOn = const Value.absent(),
                Value<String?> warrantyUntil = const Value.absent(),
                Value<int?> serviceIntervalDays = const Value.absent(),
                Value<String?> nextServiceDue = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MachinesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                companyId: companyId,
                name: name,
                category: category,
                manufacturer: manufacturer,
                model: model,
                serialNumber: serialNumber,
                location: location,
                installedOn: installedOn,
                warrantyUntil: warrantyUntil,
                serviceIntervalDays: serviceIntervalDays,
                nextServiceDue: nextServiceDue,
                status: status,
                notes: notes,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String companyId,
                required String name,
                Value<String> category = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> serialNumber = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> installedOn = const Value.absent(),
                Value<String?> warrantyUntil = const Value.absent(),
                Value<int?> serviceIntervalDays = const Value.absent(),
                Value<String?> nextServiceDue = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MachinesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                companyId: companyId,
                name: name,
                category: category,
                manufacturer: manufacturer,
                model: model,
                serialNumber: serialNumber,
                location: location,
                installedOn: installedOn,
                warrantyUntil: warrantyUntil,
                serviceIntervalDays: serviceIntervalDays,
                nextServiceDue: nextServiceDue,
                status: status,
                notes: notes,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MachinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                companyId = false,
                serviceVisitsRefs = false,
                remindersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serviceVisitsRefs) db.serviceVisits,
                    if (remindersRefs) db.reminders,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (companyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.companyId,
                                    referencedTable: $$MachinesTableReferences
                                        ._companyIdTable(db),
                                    referencedColumn: $$MachinesTableReferences
                                        ._companyIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serviceVisitsRefs)
                        await $_getPrefetchedData<
                          Machine,
                          $MachinesTable,
                          ServiceVisit
                        >(
                          currentTable: table,
                          referencedTable: $$MachinesTableReferences
                              ._serviceVisitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MachinesTableReferences(
                                db,
                                table,
                                p0,
                              ).serviceVisitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.machineId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          Machine,
                          $MachinesTable,
                          Reminder
                        >(
                          currentTable: table,
                          referencedTable: $$MachinesTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MachinesTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.machineId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MachinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MachinesTable,
      Machine,
      $$MachinesTableFilterComposer,
      $$MachinesTableOrderingComposer,
      $$MachinesTableAnnotationComposer,
      $$MachinesTableCreateCompanionBuilder,
      $$MachinesTableUpdateCompanionBuilder,
      (Machine, $$MachinesTableReferences),
      Machine,
      PrefetchHooks Function({
        bool companyId,
        bool serviceVisitsRefs,
        bool remindersRefs,
      })
    >;
typedef $$PartsTableCreateCompanionBuilder =
    PartsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String name,
      Value<String?> partNumber,
      Value<String?> category,
      Value<String> unit,
      Value<int> minStockMilli,
      Value<int?> purchasePaise,
      Value<int?> sellingPaise,
      Value<String?> supplierName,
      Value<String?> supplierContact,
      Value<String?> notes,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$PartsTableUpdateCompanionBuilder =
    PartsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> name,
      Value<String?> partNumber,
      Value<String?> category,
      Value<String> unit,
      Value<int> minStockMilli,
      Value<int?> purchasePaise,
      Value<int?> sellingPaise,
      Value<String?> supplierName,
      Value<String?> supplierContact,
      Value<String?> notes,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$PartsTableReferences
    extends BaseReferences<_$AppDatabase, $PartsTable, Part> {
  $$PartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VisitPartsTable, List<VisitPart>>
  _visitPartsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.visitParts,
    aliasName: 'parts__id__visit_parts__part_id',
  );

  $$VisitPartsTableProcessedTableManager get visitPartsRefs {
    final manager = $$VisitPartsTableTableManager(
      $_db,
      $_db.visitParts,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_visitPartsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'parts__id__stock_movements__part_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager(
      $_db,
      $_db.stockMovements,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PartsTableFilterComposer extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partNumber => $composableBuilder(
    column: $table.partNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minStockMilli => $composableBuilder(
    column: $table.minStockMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePaise => $composableBuilder(
    column: $table.purchasePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPaise => $composableBuilder(
    column: $table.sellingPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierContact => $composableBuilder(
    column: $table.supplierContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> visitPartsRefs(
    Expression<bool> Function($$VisitPartsTableFilterComposer f) f,
  ) {
    final $$VisitPartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visitParts,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitPartsTableFilterComposer(
            $db: $db,
            $table: $db.visitParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partNumber => $composableBuilder(
    column: $table.partNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minStockMilli => $composableBuilder(
    column: $table.minStockMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePaise => $composableBuilder(
    column: $table.purchasePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPaise => $composableBuilder(
    column: $table.sellingPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierContact => $composableBuilder(
    column: $table.supplierContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get partNumber => $composableBuilder(
    column: $table.partNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get minStockMilli => $composableBuilder(
    column: $table.minStockMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get purchasePaise => $composableBuilder(
    column: $table.purchasePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sellingPaise => $composableBuilder(
    column: $table.sellingPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierContact => $composableBuilder(
    column: $table.supplierContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> visitPartsRefs<T extends Object>(
    Expression<T> Function($$VisitPartsTableAnnotationComposer a) f,
  ) {
    final $$VisitPartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visitParts,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitPartsTableAnnotationComposer(
            $db: $db,
            $table: $db.visitParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartsTable,
          Part,
          $$PartsTableFilterComposer,
          $$PartsTableOrderingComposer,
          $$PartsTableAnnotationComposer,
          $$PartsTableCreateCompanionBuilder,
          $$PartsTableUpdateCompanionBuilder,
          (Part, $$PartsTableReferences),
          Part,
          PrefetchHooks Function({bool visitPartsRefs, bool stockMovementsRefs})
        > {
  $$PartsTableTableManager(_$AppDatabase db, $PartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> partNumber = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> minStockMilli = const Value.absent(),
                Value<int?> purchasePaise = const Value.absent(),
                Value<int?> sellingPaise = const Value.absent(),
                Value<String?> supplierName = const Value.absent(),
                Value<String?> supplierContact = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                name: name,
                partNumber: partNumber,
                category: category,
                unit: unit,
                minStockMilli: minStockMilli,
                purchasePaise: purchasePaise,
                sellingPaise: sellingPaise,
                supplierName: supplierName,
                supplierContact: supplierContact,
                notes: notes,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String name,
                Value<String?> partNumber = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> minStockMilli = const Value.absent(),
                Value<int?> purchasePaise = const Value.absent(),
                Value<int?> sellingPaise = const Value.absent(),
                Value<String?> supplierName = const Value.absent(),
                Value<String?> supplierContact = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                name: name,
                partNumber: partNumber,
                category: category,
                unit: unit,
                minStockMilli: minStockMilli,
                purchasePaise: purchasePaise,
                sellingPaise: sellingPaise,
                supplierName: supplierName,
                supplierContact: supplierContact,
                notes: notes,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PartsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({visitPartsRefs = false, stockMovementsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (visitPartsRefs) db.visitParts,
                    if (stockMovementsRefs) db.stockMovements,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (visitPartsRefs)
                        await $_getPrefetchedData<Part, $PartsTable, VisitPart>(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._visitPartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).visitPartsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockMovementsRefs)
                        await $_getPrefetchedData<
                          Part,
                          $PartsTable,
                          StockMovement
                        >(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartsTable,
      Part,
      $$PartsTableFilterComposer,
      $$PartsTableOrderingComposer,
      $$PartsTableAnnotationComposer,
      $$PartsTableCreateCompanionBuilder,
      $$PartsTableUpdateCompanionBuilder,
      (Part, $$PartsTableReferences),
      Part,
      PrefetchHooks Function({bool visitPartsRefs, bool stockMovementsRefs})
    >;
typedef $$ServiceVisitsTableCreateCompanionBuilder =
    ServiceVisitsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String visitNo,
      required String companyId,
      Value<String?> machineId,
      required String visitDate,
      Value<String?> arrivalTime,
      Value<String?> departureTime,
      Value<String> serviceType,
      Value<String> status,
      Value<String?> technicianName,
      Value<String?> reportedProblem,
      Value<String?> symptoms,
      Value<String?> diagnosis,
      Value<String?> rootCause,
      Value<String?> workDone,
      Value<String?> actionsTaken,
      Value<String?> testsPerformed,
      Value<String?> machineStatusAfter,
      Value<String?> recommendations,
      Value<int> labourPaise,
      Value<int> travelPaise,
      Value<int> discountPaise,
      Value<int> taxRateBp,
      Value<int> partsTotalPaise,
      Value<int> totalPaise,
      Value<int> onsitePaymentPaise,
      Value<String?> onsitePaymentMethod,
      Value<String?> customerFeedback,
      Value<String?> signedBy,
      Value<String?> nextServiceDate,
      Value<String?> internalNotes,
      Value<DateTime?> completedAt,
      Value<String?> invoiceId,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$ServiceVisitsTableUpdateCompanionBuilder =
    ServiceVisitsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> visitNo,
      Value<String> companyId,
      Value<String?> machineId,
      Value<String> visitDate,
      Value<String?> arrivalTime,
      Value<String?> departureTime,
      Value<String> serviceType,
      Value<String> status,
      Value<String?> technicianName,
      Value<String?> reportedProblem,
      Value<String?> symptoms,
      Value<String?> diagnosis,
      Value<String?> rootCause,
      Value<String?> workDone,
      Value<String?> actionsTaken,
      Value<String?> testsPerformed,
      Value<String?> machineStatusAfter,
      Value<String?> recommendations,
      Value<int> labourPaise,
      Value<int> travelPaise,
      Value<int> discountPaise,
      Value<int> taxRateBp,
      Value<int> partsTotalPaise,
      Value<int> totalPaise,
      Value<int> onsitePaymentPaise,
      Value<String?> onsitePaymentMethod,
      Value<String?> customerFeedback,
      Value<String?> signedBy,
      Value<String?> nextServiceDate,
      Value<String?> internalNotes,
      Value<DateTime?> completedAt,
      Value<String?> invoiceId,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$ServiceVisitsTableReferences
    extends BaseReferences<_$AppDatabase, $ServiceVisitsTable, ServiceVisit> {
  $$ServiceVisitsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('service_visits__company_id__companies__id');

  $$CompaniesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<String>('company_id')!;

    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MachinesTable _machineIdTable(_$AppDatabase db) =>
      db.machines.createAlias('service_visits__machine_id__machines__id');

  $$MachinesTableProcessedTableManager? get machineId {
    final $_column = $_itemColumn<String>('machine_id');
    if ($_column == null) return null;
    final manager = $$MachinesTableTableManager(
      $_db,
      $_db.machines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_machineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VisitPartsTable, List<VisitPart>>
  _visitPartsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.visitParts,
    aliasName: 'service_visits__id__visit_parts__visit_id',
  );

  $$VisitPartsTableProcessedTableManager get visitPartsRefs {
    final manager = $$VisitPartsTableTableManager(
      $_db,
      $_db.visitParts,
    ).filter((f) => f.visitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_visitPartsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServiceVisitsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceVisitsTable> {
  $$ServiceVisitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitNo => $composableBuilder(
    column: $table.visitNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitDate => $composableBuilder(
    column: $table.visitDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departureTime => $composableBuilder(
    column: $table.departureTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get technicianName => $composableBuilder(
    column: $table.technicianName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportedProblem => $composableBuilder(
    column: $table.reportedProblem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootCause => $composableBuilder(
    column: $table.rootCause,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workDone => $composableBuilder(
    column: $table.workDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionsTaken => $composableBuilder(
    column: $table.actionsTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testsPerformed => $composableBuilder(
    column: $table.testsPerformed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get machineStatusAfter => $composableBuilder(
    column: $table.machineStatusAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get labourPaise => $composableBuilder(
    column: $table.labourPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get travelPaise => $composableBuilder(
    column: $table.travelPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountPaise => $composableBuilder(
    column: $table.discountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxRateBp => $composableBuilder(
    column: $table.taxRateBp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get partsTotalPaise => $composableBuilder(
    column: $table.partsTotalPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onsitePaymentPaise => $composableBuilder(
    column: $table.onsitePaymentPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get onsitePaymentMethod => $composableBuilder(
    column: $table.onsitePaymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerFeedback => $composableBuilder(
    column: $table.customerFeedback,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signedBy => $composableBuilder(
    column: $table.signedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceId => $composableBuilder(
    column: $table.invoiceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MachinesTableFilterComposer get machineId {
    final $$MachinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.machineId,
      referencedTable: $db.machines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MachinesTableFilterComposer(
            $db: $db,
            $table: $db.machines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> visitPartsRefs(
    Expression<bool> Function($$VisitPartsTableFilterComposer f) f,
  ) {
    final $$VisitPartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visitParts,
      getReferencedColumn: (t) => t.visitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitPartsTableFilterComposer(
            $db: $db,
            $table: $db.visitParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceVisitsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceVisitsTable> {
  $$ServiceVisitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitNo => $composableBuilder(
    column: $table.visitNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitDate => $composableBuilder(
    column: $table.visitDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departureTime => $composableBuilder(
    column: $table.departureTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get technicianName => $composableBuilder(
    column: $table.technicianName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportedProblem => $composableBuilder(
    column: $table.reportedProblem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootCause => $composableBuilder(
    column: $table.rootCause,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workDone => $composableBuilder(
    column: $table.workDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionsTaken => $composableBuilder(
    column: $table.actionsTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testsPerformed => $composableBuilder(
    column: $table.testsPerformed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get machineStatusAfter => $composableBuilder(
    column: $table.machineStatusAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get labourPaise => $composableBuilder(
    column: $table.labourPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get travelPaise => $composableBuilder(
    column: $table.travelPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountPaise => $composableBuilder(
    column: $table.discountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxRateBp => $composableBuilder(
    column: $table.taxRateBp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get partsTotalPaise => $composableBuilder(
    column: $table.partsTotalPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onsitePaymentPaise => $composableBuilder(
    column: $table.onsitePaymentPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get onsitePaymentMethod => $composableBuilder(
    column: $table.onsitePaymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerFeedback => $composableBuilder(
    column: $table.customerFeedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signedBy => $composableBuilder(
    column: $table.signedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceId => $composableBuilder(
    column: $table.invoiceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MachinesTableOrderingComposer get machineId {
    final $$MachinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.machineId,
      referencedTable: $db.machines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MachinesTableOrderingComposer(
            $db: $db,
            $table: $db.machines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServiceVisitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceVisitsTable> {
  $$ServiceVisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get visitNo =>
      $composableBuilder(column: $table.visitNo, builder: (column) => column);

  GeneratedColumn<String> get visitDate =>
      $composableBuilder(column: $table.visitDate, builder: (column) => column);

  GeneratedColumn<String> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departureTime => $composableBuilder(
    column: $table.departureTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get technicianName => $composableBuilder(
    column: $table.technicianName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reportedProblem => $composableBuilder(
    column: $table.reportedProblem,
    builder: (column) => column,
  );

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get diagnosis =>
      $composableBuilder(column: $table.diagnosis, builder: (column) => column);

  GeneratedColumn<String> get rootCause =>
      $composableBuilder(column: $table.rootCause, builder: (column) => column);

  GeneratedColumn<String> get workDone =>
      $composableBuilder(column: $table.workDone, builder: (column) => column);

  GeneratedColumn<String> get actionsTaken => $composableBuilder(
    column: $table.actionsTaken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get testsPerformed => $composableBuilder(
    column: $table.testsPerformed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get machineStatusAfter => $composableBuilder(
    column: $table.machineStatusAfter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => column,
  );

  GeneratedColumn<int> get labourPaise => $composableBuilder(
    column: $table.labourPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get travelPaise => $composableBuilder(
    column: $table.travelPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountPaise => $composableBuilder(
    column: $table.discountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxRateBp =>
      $composableBuilder(column: $table.taxRateBp, builder: (column) => column);

  GeneratedColumn<int> get partsTotalPaise => $composableBuilder(
    column: $table.partsTotalPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get onsitePaymentPaise => $composableBuilder(
    column: $table.onsitePaymentPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get onsitePaymentMethod => $composableBuilder(
    column: $table.onsitePaymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerFeedback => $composableBuilder(
    column: $table.customerFeedback,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signedBy =>
      $composableBuilder(column: $table.signedBy, builder: (column) => column);

  GeneratedColumn<String> get nextServiceDate => $composableBuilder(
    column: $table.nextServiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceId =>
      $composableBuilder(column: $table.invoiceId, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MachinesTableAnnotationComposer get machineId {
    final $$MachinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.machineId,
      referencedTable: $db.machines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MachinesTableAnnotationComposer(
            $db: $db,
            $table: $db.machines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> visitPartsRefs<T extends Object>(
    Expression<T> Function($$VisitPartsTableAnnotationComposer a) f,
  ) {
    final $$VisitPartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visitParts,
      getReferencedColumn: (t) => t.visitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitPartsTableAnnotationComposer(
            $db: $db,
            $table: $db.visitParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceVisitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceVisitsTable,
          ServiceVisit,
          $$ServiceVisitsTableFilterComposer,
          $$ServiceVisitsTableOrderingComposer,
          $$ServiceVisitsTableAnnotationComposer,
          $$ServiceVisitsTableCreateCompanionBuilder,
          $$ServiceVisitsTableUpdateCompanionBuilder,
          (ServiceVisit, $$ServiceVisitsTableReferences),
          ServiceVisit,
          PrefetchHooks Function({
            bool companyId,
            bool machineId,
            bool visitPartsRefs,
          })
        > {
  $$ServiceVisitsTableTableManager(_$AppDatabase db, $ServiceVisitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceVisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceVisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceVisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> visitNo = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String?> machineId = const Value.absent(),
                Value<String> visitDate = const Value.absent(),
                Value<String?> arrivalTime = const Value.absent(),
                Value<String?> departureTime = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> technicianName = const Value.absent(),
                Value<String?> reportedProblem = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String?> rootCause = const Value.absent(),
                Value<String?> workDone = const Value.absent(),
                Value<String?> actionsTaken = const Value.absent(),
                Value<String?> testsPerformed = const Value.absent(),
                Value<String?> machineStatusAfter = const Value.absent(),
                Value<String?> recommendations = const Value.absent(),
                Value<int> labourPaise = const Value.absent(),
                Value<int> travelPaise = const Value.absent(),
                Value<int> discountPaise = const Value.absent(),
                Value<int> taxRateBp = const Value.absent(),
                Value<int> partsTotalPaise = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
                Value<int> onsitePaymentPaise = const Value.absent(),
                Value<String?> onsitePaymentMethod = const Value.absent(),
                Value<String?> customerFeedback = const Value.absent(),
                Value<String?> signedBy = const Value.absent(),
                Value<String?> nextServiceDate = const Value.absent(),
                Value<String?> internalNotes = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> invoiceId = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceVisitsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                visitNo: visitNo,
                companyId: companyId,
                machineId: machineId,
                visitDate: visitDate,
                arrivalTime: arrivalTime,
                departureTime: departureTime,
                serviceType: serviceType,
                status: status,
                technicianName: technicianName,
                reportedProblem: reportedProblem,
                symptoms: symptoms,
                diagnosis: diagnosis,
                rootCause: rootCause,
                workDone: workDone,
                actionsTaken: actionsTaken,
                testsPerformed: testsPerformed,
                machineStatusAfter: machineStatusAfter,
                recommendations: recommendations,
                labourPaise: labourPaise,
                travelPaise: travelPaise,
                discountPaise: discountPaise,
                taxRateBp: taxRateBp,
                partsTotalPaise: partsTotalPaise,
                totalPaise: totalPaise,
                onsitePaymentPaise: onsitePaymentPaise,
                onsitePaymentMethod: onsitePaymentMethod,
                customerFeedback: customerFeedback,
                signedBy: signedBy,
                nextServiceDate: nextServiceDate,
                internalNotes: internalNotes,
                completedAt: completedAt,
                invoiceId: invoiceId,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String visitNo,
                required String companyId,
                Value<String?> machineId = const Value.absent(),
                required String visitDate,
                Value<String?> arrivalTime = const Value.absent(),
                Value<String?> departureTime = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> technicianName = const Value.absent(),
                Value<String?> reportedProblem = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String?> rootCause = const Value.absent(),
                Value<String?> workDone = const Value.absent(),
                Value<String?> actionsTaken = const Value.absent(),
                Value<String?> testsPerformed = const Value.absent(),
                Value<String?> machineStatusAfter = const Value.absent(),
                Value<String?> recommendations = const Value.absent(),
                Value<int> labourPaise = const Value.absent(),
                Value<int> travelPaise = const Value.absent(),
                Value<int> discountPaise = const Value.absent(),
                Value<int> taxRateBp = const Value.absent(),
                Value<int> partsTotalPaise = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
                Value<int> onsitePaymentPaise = const Value.absent(),
                Value<String?> onsitePaymentMethod = const Value.absent(),
                Value<String?> customerFeedback = const Value.absent(),
                Value<String?> signedBy = const Value.absent(),
                Value<String?> nextServiceDate = const Value.absent(),
                Value<String?> internalNotes = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> invoiceId = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceVisitsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                visitNo: visitNo,
                companyId: companyId,
                machineId: machineId,
                visitDate: visitDate,
                arrivalTime: arrivalTime,
                departureTime: departureTime,
                serviceType: serviceType,
                status: status,
                technicianName: technicianName,
                reportedProblem: reportedProblem,
                symptoms: symptoms,
                diagnosis: diagnosis,
                rootCause: rootCause,
                workDone: workDone,
                actionsTaken: actionsTaken,
                testsPerformed: testsPerformed,
                machineStatusAfter: machineStatusAfter,
                recommendations: recommendations,
                labourPaise: labourPaise,
                travelPaise: travelPaise,
                discountPaise: discountPaise,
                taxRateBp: taxRateBp,
                partsTotalPaise: partsTotalPaise,
                totalPaise: totalPaise,
                onsitePaymentPaise: onsitePaymentPaise,
                onsitePaymentMethod: onsitePaymentMethod,
                customerFeedback: customerFeedback,
                signedBy: signedBy,
                nextServiceDate: nextServiceDate,
                internalNotes: internalNotes,
                completedAt: completedAt,
                invoiceId: invoiceId,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServiceVisitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({companyId = false, machineId = false, visitPartsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (visitPartsRefs) db.visitParts],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (companyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.companyId,
                                    referencedTable:
                                        $$ServiceVisitsTableReferences
                                            ._companyIdTable(db),
                                    referencedColumn:
                                        $$ServiceVisitsTableReferences
                                            ._companyIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (machineId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.machineId,
                                    referencedTable:
                                        $$ServiceVisitsTableReferences
                                            ._machineIdTable(db),
                                    referencedColumn:
                                        $$ServiceVisitsTableReferences
                                            ._machineIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (visitPartsRefs)
                        await $_getPrefetchedData<
                          ServiceVisit,
                          $ServiceVisitsTable,
                          VisitPart
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceVisitsTableReferences
                              ._visitPartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceVisitsTableReferences(
                                db,
                                table,
                                p0,
                              ).visitPartsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.visitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ServiceVisitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceVisitsTable,
      ServiceVisit,
      $$ServiceVisitsTableFilterComposer,
      $$ServiceVisitsTableOrderingComposer,
      $$ServiceVisitsTableAnnotationComposer,
      $$ServiceVisitsTableCreateCompanionBuilder,
      $$ServiceVisitsTableUpdateCompanionBuilder,
      (ServiceVisit, $$ServiceVisitsTableReferences),
      ServiceVisit,
      PrefetchHooks Function({
        bool companyId,
        bool machineId,
        bool visitPartsRefs,
      })
    >;
typedef $$VisitPartsTableCreateCompanionBuilder =
    VisitPartsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String visitId,
      Value<String?> partId,
      required String partName,
      Value<String?> partNumber,
      required int qtyMilli,
      Value<int?> unitCostPaise,
      Value<int> unitPricePaise,
      Value<int> sortOrder,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$VisitPartsTableUpdateCompanionBuilder =
    VisitPartsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> visitId,
      Value<String?> partId,
      Value<String> partName,
      Value<String?> partNumber,
      Value<int> qtyMilli,
      Value<int?> unitCostPaise,
      Value<int> unitPricePaise,
      Value<int> sortOrder,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$VisitPartsTableReferences
    extends BaseReferences<_$AppDatabase, $VisitPartsTable, VisitPart> {
  $$VisitPartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServiceVisitsTable _visitIdTable(_$AppDatabase db) =>
      db.serviceVisits.createAlias('visit_parts__visit_id__service_visits__id');

  $$ServiceVisitsTableProcessedTableManager get visitId {
    final $_column = $_itemColumn<String>('visit_id')!;

    final manager = $$ServiceVisitsTableTableManager(
      $_db,
      $_db.serviceVisits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_visitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PartsTable _partIdTable(_$AppDatabase db) =>
      db.parts.createAlias('visit_parts__part_id__parts__id');

  $$PartsTableProcessedTableManager? get partId {
    final $_column = $_itemColumn<String>('part_id');
    if ($_column == null) return null;
    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VisitPartsTableFilterComposer
    extends Composer<_$AppDatabase, $VisitPartsTable> {
  $$VisitPartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partName => $composableBuilder(
    column: $table.partName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partNumber => $composableBuilder(
    column: $table.partNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyMilli => $composableBuilder(
    column: $table.qtyMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ServiceVisitsTableFilterComposer get visitId {
    final $$ServiceVisitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visitId,
      referencedTable: $db.serviceVisits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceVisitsTableFilterComposer(
            $db: $db,
            $table: $db.serviceVisits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitPartsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitPartsTable> {
  $$VisitPartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partName => $composableBuilder(
    column: $table.partName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partNumber => $composableBuilder(
    column: $table.partNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyMilli => $composableBuilder(
    column: $table.qtyMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServiceVisitsTableOrderingComposer get visitId {
    final $$ServiceVisitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visitId,
      referencedTable: $db.serviceVisits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceVisitsTableOrderingComposer(
            $db: $db,
            $table: $db.serviceVisits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitPartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitPartsTable> {
  $$VisitPartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get partName =>
      $composableBuilder(column: $table.partName, builder: (column) => column);

  GeneratedColumn<String> get partNumber => $composableBuilder(
    column: $table.partNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qtyMilli =>
      $composableBuilder(column: $table.qtyMilli, builder: (column) => column);

  GeneratedColumn<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$ServiceVisitsTableAnnotationComposer get visitId {
    final $$ServiceVisitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visitId,
      referencedTable: $db.serviceVisits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceVisitsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceVisits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitPartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitPartsTable,
          VisitPart,
          $$VisitPartsTableFilterComposer,
          $$VisitPartsTableOrderingComposer,
          $$VisitPartsTableAnnotationComposer,
          $$VisitPartsTableCreateCompanionBuilder,
          $$VisitPartsTableUpdateCompanionBuilder,
          (VisitPart, $$VisitPartsTableReferences),
          VisitPart,
          PrefetchHooks Function({bool visitId, bool partId})
        > {
  $$VisitPartsTableTableManager(_$AppDatabase db, $VisitPartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitPartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitPartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitPartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> visitId = const Value.absent(),
                Value<String?> partId = const Value.absent(),
                Value<String> partName = const Value.absent(),
                Value<String?> partNumber = const Value.absent(),
                Value<int> qtyMilli = const Value.absent(),
                Value<int?> unitCostPaise = const Value.absent(),
                Value<int> unitPricePaise = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitPartsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                visitId: visitId,
                partId: partId,
                partName: partName,
                partNumber: partNumber,
                qtyMilli: qtyMilli,
                unitCostPaise: unitCostPaise,
                unitPricePaise: unitPricePaise,
                sortOrder: sortOrder,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String visitId,
                Value<String?> partId = const Value.absent(),
                required String partName,
                Value<String?> partNumber = const Value.absent(),
                required int qtyMilli,
                Value<int?> unitCostPaise = const Value.absent(),
                Value<int> unitPricePaise = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitPartsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                visitId: visitId,
                partId: partId,
                partName: partName,
                partNumber: partNumber,
                qtyMilli: qtyMilli,
                unitCostPaise: unitCostPaise,
                unitPricePaise: unitPricePaise,
                sortOrder: sortOrder,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VisitPartsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({visitId = false, partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (visitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.visitId,
                                referencedTable: $$VisitPartsTableReferences
                                    ._visitIdTable(db),
                                referencedColumn: $$VisitPartsTableReferences
                                    ._visitIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable: $$VisitPartsTableReferences
                                    ._partIdTable(db),
                                referencedColumn: $$VisitPartsTableReferences
                                    ._partIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VisitPartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitPartsTable,
      VisitPart,
      $$VisitPartsTableFilterComposer,
      $$VisitPartsTableOrderingComposer,
      $$VisitPartsTableAnnotationComposer,
      $$VisitPartsTableCreateCompanionBuilder,
      $$VisitPartsTableUpdateCompanionBuilder,
      (VisitPart, $$VisitPartsTableReferences),
      VisitPart,
      PrefetchHooks Function({bool visitId, bool partId})
    >;
typedef $$StockMovementsTableCreateCompanionBuilder =
    StockMovementsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String partId,
      required String kind,
      required int qtyMilli,
      Value<int?> unitCostPaise,
      Value<String?> visitId,
      Value<String?> visitPartId,
      required String occurredOn,
      Value<String?> notes,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$StockMovementsTableUpdateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> partId,
      Value<String> kind,
      Value<int> qtyMilli,
      Value<int?> unitCostPaise,
      Value<String?> visitId,
      Value<String?> visitPartId,
      Value<String> occurredOn,
      Value<String?> notes,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$StockMovementsTableReferences
    extends BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement> {
  $$StockMovementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PartsTable _partIdTable(_$AppDatabase db) =>
      db.parts.createAlias('stock_movements__part_id__parts__id');

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<String>('part_id')!;

    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyMilli => $composableBuilder(
    column: $table.qtyMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitPartId => $composableBuilder(
    column: $table.visitPartId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyMilli => $composableBuilder(
    column: $table.qtyMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitPartId => $composableBuilder(
    column: $table.visitPartId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get qtyMilli =>
      $composableBuilder(column: $table.qtyMilli, builder: (column) => column);

  GeneratedColumn<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get visitPartId => $composableBuilder(
    column: $table.visitPartId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockMovementsTable,
          StockMovement,
          $$StockMovementsTableFilterComposer,
          $$StockMovementsTableOrderingComposer,
          $$StockMovementsTableAnnotationComposer,
          $$StockMovementsTableCreateCompanionBuilder,
          $$StockMovementsTableUpdateCompanionBuilder,
          (StockMovement, $$StockMovementsTableReferences),
          StockMovement,
          PrefetchHooks Function({bool partId})
        > {
  $$StockMovementsTableTableManager(
    _$AppDatabase db,
    $StockMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> partId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> qtyMilli = const Value.absent(),
                Value<int?> unitCostPaise = const Value.absent(),
                Value<String?> visitId = const Value.absent(),
                Value<String?> visitPartId = const Value.absent(),
                Value<String> occurredOn = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                partId: partId,
                kind: kind,
                qtyMilli: qtyMilli,
                unitCostPaise: unitCostPaise,
                visitId: visitId,
                visitPartId: visitPartId,
                occurredOn: occurredOn,
                notes: notes,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String partId,
                required String kind,
                required int qtyMilli,
                Value<int?> unitCostPaise = const Value.absent(),
                Value<String?> visitId = const Value.absent(),
                Value<String?> visitPartId = const Value.absent(),
                required String occurredOn,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                partId: partId,
                kind: kind,
                qtyMilli: qtyMilli,
                unitCostPaise: unitCostPaise,
                visitId: visitId,
                visitPartId: visitPartId,
                occurredOn: occurredOn,
                notes: notes,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StockMovementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable: $$StockMovementsTableReferences
                                    ._partIdTable(db),
                                referencedColumn:
                                    $$StockMovementsTableReferences
                                        ._partIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StockMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockMovementsTable,
      StockMovement,
      $$StockMovementsTableFilterComposer,
      $$StockMovementsTableOrderingComposer,
      $$StockMovementsTableAnnotationComposer,
      $$StockMovementsTableCreateCompanionBuilder,
      $$StockMovementsTableUpdateCompanionBuilder,
      (StockMovement, $$StockMovementsTableReferences),
      StockMovement,
      PrefetchHooks Function({bool partId})
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String invoiceNo,
      required String companyId,
      required String invoiceDate,
      Value<String?> dueDate,
      required String billToName,
      Value<String?> billToAddress,
      Value<String?> billToPhone,
      Value<String?> billToGstin,
      Value<int> discountPaise,
      Value<String?> taxLabel,
      Value<int> taxRateBp,
      Value<int> subtotalPaise,
      Value<int> taxPaise,
      Value<int> totalPaise,
      Value<String?> notes,
      Value<DateTime?> cancelledAt,
      Value<String?> cancelReason,
      Value<int> rowid,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> invoiceNo,
      Value<String> companyId,
      Value<String> invoiceDate,
      Value<String?> dueDate,
      Value<String> billToName,
      Value<String?> billToAddress,
      Value<String?> billToPhone,
      Value<String?> billToGstin,
      Value<int> discountPaise,
      Value<String?> taxLabel,
      Value<int> taxRateBp,
      Value<int> subtotalPaise,
      Value<int> taxPaise,
      Value<int> totalPaise,
      Value<String?> notes,
      Value<DateTime?> cancelledAt,
      Value<String?> cancelReason,
      Value<int> rowid,
    });

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, Invoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('invoices__company_id__companies__id');

  $$CompaniesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<String>('company_id')!;

    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoiceItemsTable, List<InvoiceItem>>
  _invoiceItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceItems,
    aliasName: 'invoices__id__invoice_items__invoice_id',
  );

  $$InvoiceItemsTableProcessedTableManager get invoiceItemsRefs {
    final manager = $$InvoiceItemsTableTableManager(
      $_db,
      $_db.invoiceItems,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentAllocationsTable, List<PaymentAllocation>>
  _paymentAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paymentAllocations,
        aliasName: 'invoices__id__payment_allocations__invoice_id',
      );

  $$PaymentAllocationsTableProcessedTableManager get paymentAllocationsRefs {
    final manager = $$PaymentAllocationsTableTableManager(
      $_db,
      $_db.paymentAllocations,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paymentAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'invoices__id__reminders__invoice_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNo => $composableBuilder(
    column: $table.invoiceNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billToName => $composableBuilder(
    column: $table.billToName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billToAddress => $composableBuilder(
    column: $table.billToAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billToPhone => $composableBuilder(
    column: $table.billToPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billToGstin => $composableBuilder(
    column: $table.billToGstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountPaise => $composableBuilder(
    column: $table.discountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxLabel => $composableBuilder(
    column: $table.taxLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxRateBp => $composableBuilder(
    column: $table.taxRateBp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalPaise => $composableBuilder(
    column: $table.subtotalPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxPaise => $composableBuilder(
    column: $table.taxPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnFilters(column),
  );

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoiceItemsRefs(
    Expression<bool> Function($$InvoiceItemsTableFilterComposer f) f,
  ) {
    final $$InvoiceItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentAllocationsRefs(
    Expression<bool> Function($$PaymentAllocationsTableFilterComposer f) f,
  ) {
    final $$PaymentAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAllocations,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.paymentAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNo => $composableBuilder(
    column: $table.invoiceNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billToName => $composableBuilder(
    column: $table.billToName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billToAddress => $composableBuilder(
    column: $table.billToAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billToPhone => $composableBuilder(
    column: $table.billToPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billToGstin => $composableBuilder(
    column: $table.billToGstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountPaise => $composableBuilder(
    column: $table.discountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxLabel => $composableBuilder(
    column: $table.taxLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxRateBp => $composableBuilder(
    column: $table.taxRateBp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalPaise => $composableBuilder(
    column: $table.subtotalPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxPaise => $composableBuilder(
    column: $table.taxPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get invoiceNo =>
      $composableBuilder(column: $table.invoiceNo, builder: (column) => column);

  GeneratedColumn<String> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get billToName => $composableBuilder(
    column: $table.billToName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get billToAddress => $composableBuilder(
    column: $table.billToAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get billToPhone => $composableBuilder(
    column: $table.billToPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get billToGstin => $composableBuilder(
    column: $table.billToGstin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountPaise => $composableBuilder(
    column: $table.discountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taxLabel =>
      $composableBuilder(column: $table.taxLabel, builder: (column) => column);

  GeneratedColumn<int> get taxRateBp =>
      $composableBuilder(column: $table.taxRateBp, builder: (column) => column);

  GeneratedColumn<int> get subtotalPaise => $composableBuilder(
    column: $table.subtotalPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxPaise =>
      $composableBuilder(column: $table.taxPaise, builder: (column) => column);

  GeneratedColumn<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => column,
  );

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoiceItemsRefs<T extends Object>(
    Expression<T> Function($$InvoiceItemsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentAllocationsRefs<T extends Object>(
    Expression<T> Function($$PaymentAllocationsTableAnnotationComposer a) f,
  ) {
    final $$PaymentAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paymentAllocations,
          getReferencedColumn: (t) => t.invoiceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaymentAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.paymentAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, $$InvoicesTableReferences),
          Invoice,
          PrefetchHooks Function({
            bool companyId,
            bool invoiceItemsRefs,
            bool paymentAllocationsRefs,
            bool remindersRefs,
          })
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> invoiceNo = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String> invoiceDate = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String> billToName = const Value.absent(),
                Value<String?> billToAddress = const Value.absent(),
                Value<String?> billToPhone = const Value.absent(),
                Value<String?> billToGstin = const Value.absent(),
                Value<int> discountPaise = const Value.absent(),
                Value<String?> taxLabel = const Value.absent(),
                Value<int> taxRateBp = const Value.absent(),
                Value<int> subtotalPaise = const Value.absent(),
                Value<int> taxPaise = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                invoiceNo: invoiceNo,
                companyId: companyId,
                invoiceDate: invoiceDate,
                dueDate: dueDate,
                billToName: billToName,
                billToAddress: billToAddress,
                billToPhone: billToPhone,
                billToGstin: billToGstin,
                discountPaise: discountPaise,
                taxLabel: taxLabel,
                taxRateBp: taxRateBp,
                subtotalPaise: subtotalPaise,
                taxPaise: taxPaise,
                totalPaise: totalPaise,
                notes: notes,
                cancelledAt: cancelledAt,
                cancelReason: cancelReason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String invoiceNo,
                required String companyId,
                required String invoiceDate,
                Value<String?> dueDate = const Value.absent(),
                required String billToName,
                Value<String?> billToAddress = const Value.absent(),
                Value<String?> billToPhone = const Value.absent(),
                Value<String?> billToGstin = const Value.absent(),
                Value<int> discountPaise = const Value.absent(),
                Value<String?> taxLabel = const Value.absent(),
                Value<int> taxRateBp = const Value.absent(),
                Value<int> subtotalPaise = const Value.absent(),
                Value<int> taxPaise = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                invoiceNo: invoiceNo,
                companyId: companyId,
                invoiceDate: invoiceDate,
                dueDate: dueDate,
                billToName: billToName,
                billToAddress: billToAddress,
                billToPhone: billToPhone,
                billToGstin: billToGstin,
                discountPaise: discountPaise,
                taxLabel: taxLabel,
                taxRateBp: taxRateBp,
                subtotalPaise: subtotalPaise,
                taxPaise: taxPaise,
                totalPaise: totalPaise,
                notes: notes,
                cancelledAt: cancelledAt,
                cancelReason: cancelReason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                companyId = false,
                invoiceItemsRefs = false,
                paymentAllocationsRefs = false,
                remindersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceItemsRefs) db.invoiceItems,
                    if (paymentAllocationsRefs) db.paymentAllocations,
                    if (remindersRefs) db.reminders,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (companyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.companyId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._companyIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._companyIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceItemsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          InvoiceItem
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._invoiceItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentAllocationsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          PaymentAllocation
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._paymentAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          Reminder
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, $$InvoicesTableReferences),
      Invoice,
      PrefetchHooks Function({
        bool companyId,
        bool invoiceItemsRefs,
        bool paymentAllocationsRefs,
        bool remindersRefs,
      })
    >;
typedef $$InvoiceItemsTableCreateCompanionBuilder =
    InvoiceItemsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String invoiceId,
      Value<String?> visitId,
      Value<String> kind,
      required String description,
      Value<int> qtyMilli,
      Value<int> unitPricePaise,
      Value<int> amountPaise,
      Value<int> sortOrder,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$InvoiceItemsTableUpdateCompanionBuilder =
    InvoiceItemsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> invoiceId,
      Value<String?> visitId,
      Value<String> kind,
      Value<String> description,
      Value<int> qtyMilli,
      Value<int> unitPricePaise,
      Value<int> amountPaise,
      Value<int> sortOrder,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$InvoiceItemsTableReferences
    extends BaseReferences<_$AppDatabase, $InvoiceItemsTable, InvoiceItem> {
  $$InvoiceItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('invoice_items__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoiceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyMilli => $composableBuilder(
    column: $table.qtyMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyMilli => $composableBuilder(
    column: $table.qtyMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qtyMilli =>
      $composableBuilder(column: $table.qtyMilli, builder: (column) => column);

  GeneratedColumn<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceItemsTable,
          InvoiceItem,
          $$InvoiceItemsTableFilterComposer,
          $$InvoiceItemsTableOrderingComposer,
          $$InvoiceItemsTableAnnotationComposer,
          $$InvoiceItemsTableCreateCompanionBuilder,
          $$InvoiceItemsTableUpdateCompanionBuilder,
          (InvoiceItem, $$InvoiceItemsTableReferences),
          InvoiceItem,
          PrefetchHooks Function({bool invoiceId})
        > {
  $$InvoiceItemsTableTableManager(_$AppDatabase db, $InvoiceItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> invoiceId = const Value.absent(),
                Value<String?> visitId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> qtyMilli = const Value.absent(),
                Value<int> unitPricePaise = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoiceItemsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                invoiceId: invoiceId,
                visitId: visitId,
                kind: kind,
                description: description,
                qtyMilli: qtyMilli,
                unitPricePaise: unitPricePaise,
                amountPaise: amountPaise,
                sortOrder: sortOrder,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String invoiceId,
                Value<String?> visitId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                required String description,
                Value<int> qtyMilli = const Value.absent(),
                Value<int> unitPricePaise = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoiceItemsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                invoiceId: invoiceId,
                visitId: visitId,
                kind: kind,
                description: description,
                qtyMilli: qtyMilli,
                unitPricePaise: unitPricePaise,
                amountPaise: amountPaise,
                sortOrder: sortOrder,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoiceItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable: $$InvoiceItemsTableReferences
                                    ._invoiceIdTable(db),
                                referencedColumn: $$InvoiceItemsTableReferences
                                    ._invoiceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvoiceItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceItemsTable,
      InvoiceItem,
      $$InvoiceItemsTableFilterComposer,
      $$InvoiceItemsTableOrderingComposer,
      $$InvoiceItemsTableAnnotationComposer,
      $$InvoiceItemsTableCreateCompanionBuilder,
      $$InvoiceItemsTableUpdateCompanionBuilder,
      (InvoiceItem, $$InvoiceItemsTableReferences),
      InvoiceItem,
      PrefetchHooks Function({bool invoiceId})
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String receiptNo,
      required String companyId,
      required String paidOn,
      required int amountPaise,
      Value<String> method,
      Value<String?> reference,
      Value<String?> notes,
      Value<DateTime?> voidedAt,
      Value<String?> voidReason,
      Value<int> rowid,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> receiptNo,
      Value<String> companyId,
      Value<String> paidOn,
      Value<int> amountPaise,
      Value<String> method,
      Value<String?> reference,
      Value<String?> notes,
      Value<DateTime?> voidedAt,
      Value<String?> voidReason,
      Value<int> rowid,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('payments__company_id__companies__id');

  $$CompaniesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<String>('company_id')!;

    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PaymentAllocationsTable, List<PaymentAllocation>>
  _paymentAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paymentAllocations,
        aliasName: 'payments__id__payment_allocations__payment_id',
      );

  $$PaymentAllocationsTableProcessedTableManager get paymentAllocationsRefs {
    final manager = $$PaymentAllocationsTableTableManager(
      $_db,
      $_db.paymentAllocations,
    ).filter((f) => f.paymentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paymentAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNo => $composableBuilder(
    column: $table.receiptNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidOn => $composableBuilder(
    column: $table.paidOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnFilters(column),
  );

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> paymentAllocationsRefs(
    Expression<bool> Function($$PaymentAllocationsTableFilterComposer f) f,
  ) {
    final $$PaymentAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAllocations,
      getReferencedColumn: (t) => t.paymentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.paymentAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNo => $composableBuilder(
    column: $table.receiptNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidOn => $composableBuilder(
    column: $table.paidOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get receiptNo =>
      $composableBuilder(column: $table.receiptNo, builder: (column) => column);

  GeneratedColumn<String> get paidOn =>
      $composableBuilder(column: $table.paidOn, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => column,
  );

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> paymentAllocationsRefs<T extends Object>(
    Expression<T> Function($$PaymentAllocationsTableAnnotationComposer a) f,
  ) {
    final $$PaymentAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paymentAllocations,
          getReferencedColumn: (t) => t.paymentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaymentAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.paymentAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool companyId, bool paymentAllocationsRefs})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> receiptNo = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String> paidOn = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                receiptNo: receiptNo,
                companyId: companyId,
                paidOn: paidOn,
                amountPaise: amountPaise,
                method: method,
                reference: reference,
                notes: notes,
                voidedAt: voidedAt,
                voidReason: voidReason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String receiptNo,
                required String companyId,
                required String paidOn,
                required int amountPaise,
                Value<String> method = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                receiptNo: receiptNo,
                companyId: companyId,
                paidOn: paidOn,
                amountPaise: amountPaise,
                method: method,
                reference: reference,
                notes: notes,
                voidedAt: voidedAt,
                voidReason: voidReason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({companyId = false, paymentAllocationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (paymentAllocationsRefs) db.paymentAllocations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (companyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.companyId,
                                    referencedTable: $$PaymentsTableReferences
                                        ._companyIdTable(db),
                                    referencedColumn: $$PaymentsTableReferences
                                        ._companyIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (paymentAllocationsRefs)
                        await $_getPrefetchedData<
                          Payment,
                          $PaymentsTable,
                          PaymentAllocation
                        >(
                          currentTable: table,
                          referencedTable: $$PaymentsTableReferences
                              ._paymentAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaymentsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.paymentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool companyId, bool paymentAllocationsRefs})
    >;
typedef $$PaymentAllocationsTableCreateCompanionBuilder =
    PaymentAllocationsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String paymentId,
      required String invoiceId,
      required int amountPaise,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$PaymentAllocationsTableUpdateCompanionBuilder =
    PaymentAllocationsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> paymentId,
      Value<String> invoiceId,
      Value<int> amountPaise,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$PaymentAllocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PaymentAllocationsTable,
          PaymentAllocation
        > {
  $$PaymentAllocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PaymentsTable _paymentIdTable(_$AppDatabase db) =>
      db.payments.createAlias('payment_allocations__payment_id__payments__id');

  $$PaymentsTableProcessedTableManager get paymentId {
    final $_column = $_itemColumn<String>('payment_id')!;

    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('payment_allocations__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PaymentsTableFilterComposer get paymentId {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentId,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PaymentsTableOrderingComposer get paymentId {
    final $$PaymentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentId,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableOrderingComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$PaymentsTableAnnotationComposer get paymentId {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentId,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentAllocationsTable,
          PaymentAllocation,
          $$PaymentAllocationsTableFilterComposer,
          $$PaymentAllocationsTableOrderingComposer,
          $$PaymentAllocationsTableAnnotationComposer,
          $$PaymentAllocationsTableCreateCompanionBuilder,
          $$PaymentAllocationsTableUpdateCompanionBuilder,
          (PaymentAllocation, $$PaymentAllocationsTableReferences),
          PaymentAllocation,
          PrefetchHooks Function({bool paymentId, bool invoiceId})
        > {
  $$PaymentAllocationsTableTableManager(
    _$AppDatabase db,
    $PaymentAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> paymentId = const Value.absent(),
                Value<String> invoiceId = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentAllocationsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                paymentId: paymentId,
                invoiceId: invoiceId,
                amountPaise: amountPaise,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String paymentId,
                required String invoiceId,
                required int amountPaise,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentAllocationsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                paymentId: paymentId,
                invoiceId: invoiceId,
                amountPaise: amountPaise,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentAllocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({paymentId = false, invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (paymentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.paymentId,
                                referencedTable:
                                    $$PaymentAllocationsTableReferences
                                        ._paymentIdTable(db),
                                referencedColumn:
                                    $$PaymentAllocationsTableReferences
                                        ._paymentIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable:
                                    $$PaymentAllocationsTableReferences
                                        ._invoiceIdTable(db),
                                referencedColumn:
                                    $$PaymentAllocationsTableReferences
                                        ._invoiceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentAllocationsTable,
      PaymentAllocation,
      $$PaymentAllocationsTableFilterComposer,
      $$PaymentAllocationsTableOrderingComposer,
      $$PaymentAllocationsTableAnnotationComposer,
      $$PaymentAllocationsTableCreateCompanionBuilder,
      $$PaymentAllocationsTableUpdateCompanionBuilder,
      (PaymentAllocation, $$PaymentAllocationsTableReferences),
      PaymentAllocation,
      PrefetchHooks Function({bool paymentId, bool invoiceId})
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      Value<String> kind,
      required String title,
      Value<String?> notes,
      required String dueDate,
      Value<String?> dueTime,
      Value<String?> companyId,
      Value<String?> machineId,
      Value<String?> invoiceId,
      Value<String> status,
      Value<DateTime?> doneAt,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> kind,
      Value<String> title,
      Value<String?> notes,
      Value<String> dueDate,
      Value<String?> dueTime,
      Value<String?> companyId,
      Value<String?> machineId,
      Value<String?> invoiceId,
      Value<String> status,
      Value<DateTime?> doneAt,
      Value<int> rowid,
    });

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('reminders__company_id__companies__id');

  $$CompaniesTableProcessedTableManager? get companyId {
    final $_column = $_itemColumn<String>('company_id');
    if ($_column == null) return null;
    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MachinesTable _machineIdTable(_$AppDatabase db) =>
      db.machines.createAlias('reminders__machine_id__machines__id');

  $$MachinesTableProcessedTableManager? get machineId {
    final $_column = $_itemColumn<String>('machine_id');
    if ($_column == null) return null;
    final manager = $$MachinesTableTableManager(
      $_db,
      $_db.machines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_machineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('reminders__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager? get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id');
    if ($_column == null) return null;
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MachinesTableFilterComposer get machineId {
    final $$MachinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.machineId,
      referencedTable: $db.machines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MachinesTableFilterComposer(
            $db: $db,
            $table: $db.machines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MachinesTableOrderingComposer get machineId {
    final $$MachinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.machineId,
      referencedTable: $db.machines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MachinesTableOrderingComposer(
            $db: $db,
            $table: $db.machines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get dueTime =>
      $composableBuilder(column: $table.dueTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MachinesTableAnnotationComposer get machineId {
    final $$MachinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.machineId,
      referencedTable: $db.machines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MachinesTableAnnotationComposer(
            $db: $db,
            $table: $db.machines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, $$RemindersTableReferences),
          Reminder,
          PrefetchHooks Function({
            bool companyId,
            bool machineId,
            bool invoiceId,
          })
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<String?> companyId = const Value.absent(),
                Value<String?> machineId = const Value.absent(),
                Value<String?> invoiceId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                kind: kind,
                title: title,
                notes: notes,
                dueDate: dueDate,
                dueTime: dueTime,
                companyId: companyId,
                machineId: machineId,
                invoiceId: invoiceId,
                status: status,
                doneAt: doneAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                Value<String> kind = const Value.absent(),
                required String title,
                Value<String?> notes = const Value.absent(),
                required String dueDate,
                Value<String?> dueTime = const Value.absent(),
                Value<String?> companyId = const Value.absent(),
                Value<String?> machineId = const Value.absent(),
                Value<String?> invoiceId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                kind: kind,
                title: title,
                notes: notes,
                dueDate: dueDate,
                dueTime: dueTime,
                companyId: companyId,
                machineId: machineId,
                invoiceId: invoiceId,
                status: status,
                doneAt: doneAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({companyId = false, machineId = false, invoiceId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (companyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.companyId,
                                    referencedTable: $$RemindersTableReferences
                                        ._companyIdTable(db),
                                    referencedColumn: $$RemindersTableReferences
                                        ._companyIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (machineId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.machineId,
                                    referencedTable: $$RemindersTableReferences
                                        ._machineIdTable(db),
                                    referencedColumn: $$RemindersTableReferences
                                        ._machineIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (invoiceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.invoiceId,
                                    referencedTable: $$RemindersTableReferences
                                        ._invoiceIdTable(db),
                                    referencedColumn: $$RemindersTableReferences
                                        ._invoiceIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, $$RemindersTableReferences),
      Reminder,
      PrefetchHooks Function({bool companyId, bool machineId, bool invoiceId})
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String entityType,
      required String entityId,
      required String kind,
      required String fileName,
      Value<String?> mimeType,
      Value<int?> sizeBytes,
      Value<String?> caption,
      Value<String?> storagePath,
      Value<String?> localPath,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> kind,
      Value<String> fileName,
      Value<String?> mimeType,
      Value<int?> sizeBytes,
      Value<String?> caption,
      Value<String?> storagePath,
      Value<String?> localPath,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          Attachment,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (
            Attachment,
            BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
          ),
          Attachment,
          PrefetchHooks Function()
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<int?> sizeBytes = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<String?> storagePath = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                entityType: entityType,
                entityId: entityId,
                kind: kind,
                fileName: fileName,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                caption: caption,
                storagePath: storagePath,
                localPath: localPath,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String entityType,
                required String entityId,
                required String kind,
                required String fileName,
                Value<String?> mimeType = const Value.absent(),
                Value<int?> sizeBytes = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<String?> storagePath = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                entityType: entityType,
                entityId: entityId,
                kind: kind,
                fileName: fileName,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                caption: caption,
                storagePath: storagePath,
                localPath: localPath,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      Attachment,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (
        Attachment,
        BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
      ),
      Attachment,
      PrefetchHooks Function()
    >;
typedef $$AuditLogTableCreateCompanionBuilder =
    AuditLogCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> serverRev,
      required String entityType,
      required String entityId,
      required String action,
      Value<String?> summary,
      Value<String?> changes,
      Value<String?> actor,
      Value<int> rowid,
    });
typedef $$AuditLogTableUpdateCompanionBuilder =
    AuditLogCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> serverRev,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> action,
      Value<String?> summary,
      Value<String?> changes,
      Value<String?> actor,
      Value<int> rowid,
    });

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changes => $composableBuilder(
    column: $table.changes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changes => $composableBuilder(
    column: $table.changes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get changes =>
      $composableBuilder(column: $table.changes, builder: (column) => column);

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditEntry,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditEntry,
            BaseReferences<_$AppDatabase, $AuditLogTable, AuditEntry>,
          ),
          AuditEntry,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> serverRev = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String?> changes = const Value.absent(),
                Value<String?> actor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                entityType: entityType,
                entityId: entityId,
                action: action,
                summary: summary,
                changes: changes,
                actor: actor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> serverRev = const Value.absent(),
                required String entityType,
                required String entityId,
                required String action,
                Value<String?> summary = const Value.absent(),
                Value<String?> changes = const Value.absent(),
                Value<String?> actor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverRev: serverRev,
                entityType: entityType,
                entityId: entityId,
                action: action,
                summary: summary,
                changes: changes,
                actor: actor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditEntry,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (AuditEntry, BaseReferences<_$AppDatabase, $AuditLogTable, AuditEntry>),
      AuditEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String tableName_,
      required String rowId,
      required String opId,
      required DateTime queuedAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime?> nextAttemptAt,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> tableName_,
      Value<String> rowId,
      Value<String> opId,
      Value<DateTime> queuedAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime?> nextAttemptAt,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get opId =>
      $composableBuilder(column: $table.opId, builder: (column) => column);

  GeneratedColumn<DateTime> get queuedAt =>
      $composableBuilder(column: $table.queuedAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          OutboxEntry,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tableName_ = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String> opId = const Value.absent(),
                Value<DateTime> queuedAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                tableName_: tableName_,
                rowId: rowId,
                opId: opId,
                queuedAt: queuedAt,
                attempts: attempts,
                lastError: lastError,
                nextAttemptAt: nextAttemptAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tableName_,
                required String rowId,
                required String opId,
                required DateTime queuedAt,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                tableName_: tableName_,
                rowId: rowId,
                opId: opId,
                queuedAt: queuedAt,
                attempts: attempts,
                lastError: lastError,
                nextAttemptAt: nextAttemptAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      OutboxEntry,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncConflictsTableCreateCompanionBuilder =
    SyncConflictsCompanion Function({
      required String id,
      required String tableName_,
      required String rowId,
      required String localData,
      required String serverData,
      required DateTime detectedAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });
typedef $$SyncConflictsTableUpdateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<String> id,
      Value<String> tableName_,
      Value<String> rowId,
      Value<String> localData,
      Value<String> serverData,
      Value<DateTime> detectedAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });

class $$SyncConflictsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localData => $composableBuilder(
    column: $table.localData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverData => $composableBuilder(
    column: $table.serverData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncConflictsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localData => $composableBuilder(
    column: $table.localData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverData => $composableBuilder(
    column: $table.serverData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncConflictsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get localData =>
      $composableBuilder(column: $table.localData, builder: (column) => column);

  GeneratedColumn<String> get serverData => $composableBuilder(
    column: $table.serverData,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );
}

class $$SyncConflictsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncConflictsTable,
          SyncConflict,
          $$SyncConflictsTableFilterComposer,
          $$SyncConflictsTableOrderingComposer,
          $$SyncConflictsTableAnnotationComposer,
          $$SyncConflictsTableCreateCompanionBuilder,
          $$SyncConflictsTableUpdateCompanionBuilder,
          (
            SyncConflict,
            BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflict>,
          ),
          SyncConflict,
          PrefetchHooks Function()
        > {
  $$SyncConflictsTableTableManager(_$AppDatabase db, $SyncConflictsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncConflictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncConflictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncConflictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tableName_ = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String> localData = const Value.absent(),
                Value<String> serverData = const Value.absent(),
                Value<DateTime> detectedAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictsCompanion(
                id: id,
                tableName_: tableName_,
                rowId: rowId,
                localData: localData,
                serverData: serverData,
                detectedAt: detectedAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tableName_,
                required String rowId,
                required String localData,
                required String serverData,
                required DateTime detectedAt,
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictsCompanion.insert(
                id: id,
                tableName_: tableName_,
                rowId: rowId,
                localData: localData,
                serverData: serverData,
                detectedAt: detectedAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncConflictsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncConflictsTable,
      SyncConflict,
      $$SyncConflictsTableFilterComposer,
      $$SyncConflictsTableOrderingComposer,
      $$SyncConflictsTableAnnotationComposer,
      $$SyncConflictsTableCreateCompanionBuilder,
      $$SyncConflictsTableUpdateCompanionBuilder,
      (
        SyncConflict,
        BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflict>,
      ),
      SyncConflict,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CompaniesTableTableManager get companies =>
      $$CompaniesTableTableManager(_db, _db.companies);
  $$MachinesTableTableManager get machines =>
      $$MachinesTableTableManager(_db, _db.machines);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
  $$ServiceVisitsTableTableManager get serviceVisits =>
      $$ServiceVisitsTableTableManager(_db, _db.serviceVisits);
  $$VisitPartsTableTableManager get visitParts =>
      $$VisitPartsTableTableManager(_db, _db.visitParts);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceItemsTableTableManager get invoiceItems =>
      $$InvoiceItemsTableTableManager(_db, _db.invoiceItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$PaymentAllocationsTableTableManager get paymentAllocations =>
      $$PaymentAllocationsTableTableManager(_db, _db.paymentAllocations);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$SyncConflictsTableTableManager get syncConflicts =>
      $$SyncConflictsTableTableManager(_db, _db.syncConflicts);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
