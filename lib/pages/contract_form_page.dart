import 'package:flutter/material.dart';

import '../models/contract.dart';
import '../utils/date_formatter.dart';

class ContractFormPage extends StatefulWidget {
  const ContractFormPage({super.key, this.contract});

  final Contract? contract;

  @override
  State<ContractFormPage> createState() => _ContractFormPageState();
}

class _ContractFormPageState extends State<ContractFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _validadeController;

  DateTime? _dataInicio;
  DateTime? _dataFim;
  DateTime? _dataRenovacao;
  late String _tipoProjetoSelecionado;
  late String _statusSelecionado;
  bool _temAcompanhamento = false;

  @override
  void initState() {
    super.initState();
    final Contract? contract = widget.contract;
    _nomeController = TextEditingController(text: contract?.nomeCliente ?? '');
    _validadeController = TextEditingController(
      text: contract?.validadeMeses.toString() ?? '',
    );
    _dataInicio = contract?.dataInicio;
    _dataFim = contract?.dataFim;
    _dataRenovacao = contract?.dataRenovacao;
    _tipoProjetoSelecionado = contract?.tipoProjeto ?? kTiposProjeto.first;
    _statusSelecionado = contract?.status ?? kStatusProjeto.first;
    _temAcompanhamento = contract?.temAcompanhamento ?? false;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _validadeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required String fieldLabel,
    required DateTime? currentValue,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = currentValue ?? now;
    final DateTime firstDate = DateTime(now.year - 5);
    final DateTime lastDate = DateTime(now.year + 10);
    DateTime safeInitialDate = initialDate;
    if (safeInitialDate.isBefore(firstDate)) {
      safeInitialDate = firstDate;
    } else if (safeInitialDate.isAfter(lastDate)) {
      safeInitialDate = lastDate;
    }

    final DateTime? result = await showModalBottomSheet<DateTime>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return _QuickDatePickerSheet(
          title: fieldLabel,
          initialDate: safeInitialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );
      },
    );
    if (result != null) {
      onSelected(result);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_dataInicio == null || _dataFim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Defina as datas de inicio e fim')),
      );
      return;
    }
    if (_dataFim!.isBefore(_dataInicio!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data final nao pode ser anterior ao inicio'),
        ),
      );
      return;
    }
    if (_temAcompanhamento && _dataRenovacao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data de renovacao')),
      );
      return;
    }
    final int validade = int.parse(_validadeController.text);
    final Contract resultado = Contract(
      id: widget.contract?.id,
      nomeCliente: _nomeController.text.trim(),
      dataInicio: _dataInicio!,
      dataFim: _dataFim!,
      validadeMeses: validade,
      tipoProjeto: _tipoProjetoSelecionado,
      status: _statusSelecionado,
      temAcompanhamento: _temAcompanhamento,
      dataRenovacao: _temAcompanhamento ? _dataRenovacao : null,
    );
    Navigator.of(context).pop(resultado);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.contract != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Alterar contrato' : 'Novo contrato'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do contrato / cliente',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _DatePickerTile(
                      label: 'Data inicio',
                      value: formatarData(_dataInicio),
                      onTap: () => _pickDate(
                        fieldLabel: 'Data inicio',
                        currentValue: _dataInicio,
                        onSelected: (DateTime date) {
                          setState(() => _dataInicio = date);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DatePickerTile(
                      label: 'Data fim',
                      value: formatarData(_dataFim),
                      onTap: () => _pickDate(
                        fieldLabel: 'Data fim',
                        currentValue: _dataFim,
                        onSelected: (DateTime date) {
                          setState(() => _dataFim = date);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _validadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Validade (meses)',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a validade do projeto';
                  }
                  final int? parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return 'Digite um numero maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoProjetoSelecionado,
                decoration: const InputDecoration(labelText: 'Tipo do projeto'),
                items: kTiposProjeto
                    .map(
                      (String type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() => _tipoProjetoSelecionado = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _statusSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Status do projeto',
                ),
                items: kStatusProjeto
                    .map(
                      (String status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() => _statusSelecionado = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _temAcompanhamento,
                title: const Text('Projeto com acompanhamento'),
                subtitle: const Text('Libera o campo de renovacao'),
                onChanged: (bool value) {
                  setState(() {
                    _temAcompanhamento = value;
                    if (!value) {
                      _dataRenovacao = null;
                    }
                  });
                },
              ),
              if (_temAcompanhamento)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _DatePickerTile(
                    label: 'Data de renovacao',
                    value: formatarData(_dataRenovacao),
                    onTap: () => _pickDate(
                      fieldLabel: 'Data de renovacao',
                      currentValue: _dataRenovacao,
                      onSelected: (DateTime date) {
                        setState(() => _dataRenovacao = date);
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton.icon(
                icon: const Icon(Icons.check),
                onPressed: _submit,
                label: Text(isEditing ? 'Salvar alteracoes' : 'Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickDatePickerSheet extends StatelessWidget {
  const _QuickDatePickerSheet({
    required this.title,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final String title;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Fechar calendario',
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            CalendarDatePicker(
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
              onDateChanged: (DateTime value) {
                Navigator.of(context).pop(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
