import 'package:flutter/foundation.dart';

import '../data/contract_repository.dart';
import '../models/contract.dart';

class ContractController extends ChangeNotifier {
  ContractController(this._repositorio);

  final ContractRepository _repositorio;

  List<Contract> _contratos = <Contract>[];
  bool _estaCarregando = false;
  String? _mensagemErro;

  List<Contract> get contratos => _contratos;
  bool get estaCarregando => _estaCarregando;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregarContratos() async {
    _estaCarregando = true;
    _mensagemErro = null;
    notifyListeners();
    try {
      _contratos = await _repositorio.buscarTodos();
    } catch (error) {
      _mensagemErro = 'Falha ao carregar contratos';
    } finally {
      _estaCarregando = false;
      notifyListeners();
    }
  }

  /**
   * Metodo para salvar
   */
  Future<void> salvarContrato(Contract contract) async {
    try {
      if (contract.id == null) {
        final int id = await _repositorio.inserir(contract);
        _contratos = <Contract>[..._contratos, contract.copyWith(id: id)];
      } else {
        await _repositorio.atualizar(contract);
        _contratos = _contratos
            .map((Contract item) => item.id == contract.id ? contract : item)
            .toList();
      }
      notifyListeners();
    } catch (error) {
      _mensagemErro = 'Nao foi possivel salvar o contrato';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removerContrato(int id) async {
    try {
      await _repositorio.remover(id);
      _contratos = _contratos
          .where((Contract contract) => contract.id != id)
          .toList();
      notifyListeners();
    } catch (error) {
      _mensagemErro = 'Nao foi possivel remover o contrato';
      notifyListeners();
      rethrow;
    }
  }
}
