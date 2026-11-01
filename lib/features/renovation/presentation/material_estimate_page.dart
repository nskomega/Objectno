import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/l10n.dart';
import '../../journal/data/journal_repository.dart';
import '../domain/quantity_calculator.dart';

String quantityUnitLabel(AppLocalizations l, QuantityUnit unit) =>
    switch (unit) {
      QuantityUnit.gram => l.unitGrams,
      QuantityUnit.millilitre => l.unitMillilitres,
      QuantityUnit.piece => l.unitPieces,
    };

class MaterialEstimatePage extends StatefulWidget {
  const MaterialEstimatePage({
    super.key,
    required this.repository,
    required this.objectId,
    required this.roomId,
  });
  final JournalRepository repository;
  final int objectId, roomId;
  @override
  State<MaterialEstimatePage> createState() => _MaterialEstimatePageState();
}

class _MaterialEstimatePageState extends State<MaterialEstimatePage> {
  final _form = GlobalKey<FormState>();
  final _product = TextEditingController(),
      _source = TextEditingController(),
      _rate = TextEditingController(),
      _pack = TextEditingController(),
      _layers = TextEditingController(),
      _waste = TextEditingController();
  final _surfaces = <String>{};
  QuantityUnit? _unit;
  bool _busy = false, _invalid = false, _failed = false;
  @override
  void dispose() {
    for (final c in [_product, _source, _rate, _pack, _layers, _waste]) {
      c.dispose();
    }
    super.dispose();
  }

  int? _positive(String? value) {
    final n = int.tryParse(value?.trim() ?? '');
    return n != null && n > 0 && n <= 1000000000 ? n : null;
  }

  int? _wastePoints() {
    final value = _waste.text.trim().replaceAll(',', '.');
    if (!RegExp(r'^\d{1,3}([.]\d{1,2})?$').hasMatch(value)) return null;
    final parts = value.split('.');
    final n =
        int.parse(parts.first) * 100 +
        (parts.length > 1 ? int.parse(parts.last.padRight(2, '0')) : 0);
    return n <= 10000 ? n : null;
  }

  Future<void> _save() async {
    if (_busy) return;
    final valid = _form.currentState!.validate();
    if (!valid || _surfaces.isEmpty || _unit == null) {
      setState(() => _invalid = true);
      return;
    }
    setState(() {
      _busy = true;
      _invalid = false;
      _failed = false;
    });
    try {
      await widget.repository.addMaterialEstimate(
        widget.objectId,
        widget.roomId,
        surfaceIds: _surfaces,
        product: ProductConsumption(
          productId: _product.text.trim(),
          source: _source.text.trim(),
          unit: _unit!,
          unitsPerSquareMetrePerLayer: _positive(_rate.text)!,
          unitsPerPackage: _positive(_pack.text)!,
        ),
        layers: _positive(_layers.text)!,
        wasteBasisPoints: _wastePoints()!,
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        appBar: AppBar(title: Text(l.calculateMaterials)),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l.estimateSourceNote),
                      const SizedBox(height: 16),
                      Text(
                        l.selectedSurfaces,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final surface in [
                            ('floor', l.floorSurface),
                            ('ceiling', l.ceilingSurface),
                            for (var i = 0; i < 4; i++)
                              ('wall-$i', l.wallNumber(i + 1)),
                          ])
                            FilterChip(
                              label: Text(surface.$2),
                              selected: _surfaces.contains(surface.$1),
                              onSelected: _busy
                                  ? null
                                  : (selected) => setState(() {
                                      if (selected) {
                                        _surfaces.add(surface.$1);
                                      } else {
                                        _surfaces.remove(surface.$1);
                                      }
                                    }),
                            ),
                        ],
                      ),
                      for (final field in [
                        (l.productReference, _product),
                        (l.consumptionSource, _source),
                      ]) ...[
                        const SizedBox(height: 16),
                        Text(field.$1),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: field.$2,
                          enabled: !_busy,
                          maxLength: field.$2 == _source ? 2000 : 200,
                          decoration: InputDecoration(hintText: field.$1),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? l.estimateInvalid
                              : null,
                        ),
                      ],
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final unit in QuantityUnit.values)
                            ChoiceChip(
                              label: Text(quantityUnitLabel(l, unit)),
                              selected: _unit == unit,
                              onSelected: _busy
                                  ? null
                                  : (_) => setState(() => _unit = unit),
                            ),
                        ],
                      ),
                      for (final field in [
                        (l.consumptionPerLayer, _rate),
                        (l.packageSize, _pack),
                        (l.materialLayers, _layers),
                        (l.wastePercent, _waste),
                      ]) ...[
                        const SizedBox(height: 16),
                        Text(field.$1),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: field.$2,
                          enabled: !_busy,
                          decoration: InputDecoration(hintText: field.$1),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: field.$2 == _waste,
                          ),
                          validator: (v) =>
                              (field.$2 == _waste
                                      ? _wastePoints()
                                      : _positive(v)) ==
                                  null
                              ? l.estimateInvalid
                              : null,
                        ),
                      ],
                      if (_invalid || _failed)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _failed ? l.saveFailure : l.estimateInvalid,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _busy ? null : _save,
                        child: Text(_busy ? l.pleaseWait : l.save),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MaterialEstimateDetails extends StatelessWidget {
  const MaterialEstimateDetails({super.key, required this.estimate});
  final Map estimate;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final number = NumberFormat(
      '0.###',
      Localizations.localeOf(context).languageCode,
    );
    final unit = quantityUnitLabel(
      l,
      QuantityUnit.values.byName(estimate['unit'] as String),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.estimateArea(number.format((estimate['areaMm2'] as int) / 1000000)),
        ),
        Text(
          l.estimateRequired(number.format(estimate['requiredUnits']), unit),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(l.estimatePackages(estimate['packages'] as int)),
        Text(
          '${l.consumptionPerLayer}: ${number.format(estimate['unitsPerSquareMetrePerLayer'])} $unit',
        ),
        Text(
          '${l.packageSize}: ${number.format(estimate['unitsPerPackage'])} $unit',
        ),
        Text('${l.materialLayers}: ${estimate['layers']}'),
        Text(
          '${l.wastePercent}: ${number.format((estimate['wasteBasisPoints'] as int) / 100)}',
        ),
        const SizedBox(height: 12),
        Text('${l.consumptionSource}: ${estimate['source']}'),
        Text(l.estimateSourceNote),
      ],
    );
  }
}
