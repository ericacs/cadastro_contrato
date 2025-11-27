import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/contract_controller.dart';
import '../models/contract.dart';
import '../widgets/contract_card.dart';
import 'contract_form_page.dart';

class ContractListPage extends StatefulWidget {
  const ContractListPage({super.key});

  @override
  State<ContractListPage> createState() => _ContractListPageState();
}

class _ContractListPageState extends State<ContractListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<ContractController>().carregarContratos(),
    );
  }

  Future<void> _openForm({Contract? contract}) async {
    final ContractController controlador = context.read<ContractController>();
    final Contract? resultado = await Navigator.of(context).push(
      MaterialPageRoute<Contract>(
        builder: (_) => ContractFormPage(contract: contract),
      ),
    );
    if (resultado != null) {
      await controlador.salvarContrato(resultado);
    }
  }

  Future<void> _removerContrato(Contract contract) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Remover contrato'),
          content: Text('Deseja remover o contrato "${contract.nomeCliente}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
    if (confirmar == true) {
      await context.read<ContractController>().removerContrato(contract.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contratos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo contrato'),
      ),
      body: Consumer<ContractController>(
        builder: (BuildContext context, ContractController controller, _) {
          if (controller.estaCarregando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.contratos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Nenhum contrato cadastrado.'),
                  const SizedBox(height: 5),
                  FilledButton(
                    onPressed: () => _openForm(),
                    child: const Text('Cadastrar agora'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: controller.carregarContratos,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double width = constraints.maxWidth;
                final int crossAxisCount = width >= 1100
                    ? 3
                    : width >= 700
                        ? 2
                        : 1;

                if (crossAxisCount == 1) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.contratos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      final Contract contract = controller.contratos[index];
                      return ContractCard(
                        contract: contract,
                        onEdit: () => _openForm(contract: contract),
                        onDelete: () => _removerContrato(contract),
                      );
                    },
                  );
                }

                final double totalHorizontalPadding = 32; // GridView padding * 2
                double availableWidth = width - totalHorizontalPadding;
                if (availableWidth <= 0) {
                  availableWidth = width;
                }
                final double totalSpacing = (crossAxisCount - 1) * 10;
                final double usableWidth = availableWidth - totalSpacing;
                final double itemWidth = usableWidth > 0
                    ? usableWidth / crossAxisCount
                    : width / crossAxisCount;
                final double baseHeight =
                    240 + (crossAxisCount - 2) * 30; // give multi-col cards room
                final double aspectRatio = itemWidth / baseHeight;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.contratos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final Contract contract = controller.contratos[index];
                    return ContractCard(
                      contract: contract,
                      onEdit: () => _openForm(contract: contract),
                      onDelete: () => _removerContrato(contract),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
