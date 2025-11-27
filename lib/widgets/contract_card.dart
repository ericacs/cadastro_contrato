import 'package:flutter/material.dart';

import '../models/contract.dart';
import '../utils/date_formatter.dart';

class ContractCard extends StatelessWidget {
  const ContractCard({
    super.key,
    required this.contract,
    required this.onEdit,
    required this.onDelete,
  });

  final Contract contract;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: _ContractContent(
          contract: contract,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
      ),
    );
  }
}

class _ContractContent extends StatelessWidget {
  const _ContractContent({
    required this.contract,
    required this.onEdit,
    required this.onDelete,
  });

  final Contract contract;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final List<_InfoChip> chips = <_InfoChip>[
      _InfoChip(label: 'Inicio', value: formatarData(contract.dataInicio)),
      _InfoChip(label: 'Fim', value: formatarData(contract.dataFim)),
      _InfoChip(
        label: 'Validade',
        value: '${contract.validadeMeses} meses',
      ),
      _InfoChip(label: 'Tipo', value: contract.tipoProjeto),
      _InfoChip(label: 'Status', value: contract.status),
      if (contract.temAcompanhamento)
        _InfoChip(
          label: 'Renovacao',
          value: formatarData(contract.dataRenovacao),
        ),
    ];

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < chips.length; i += 2) {
      final Widget first = chips[i];
      final Widget? second = i + 1 < chips.length ? chips[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 8 : 12),
          child: Row(
            children: <Widget>[
              Expanded(child: first),
              const SizedBox(width: 8),
              if (second != null)
                Expanded(child: second)
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                contract.nomeCliente,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Alterar'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Deletar'),
                ),
              ],
            ),
          ],
        ),
        ...rows,
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceVariant.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
      ),
    );
  }
}
