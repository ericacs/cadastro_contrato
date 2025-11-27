class Contract {
  const Contract({
    this.id,
    required this.nomeCliente,
    required this.dataInicio,
    required this.dataFim,
    required this.validadeMeses,
    required this.tipoProjeto,
    required this.status,
    required this.temAcompanhamento,
    this.dataRenovacao,
  });

  final int? id;
  final String nomeCliente;
  final DateTime dataInicio;
  final DateTime dataFim;
  final int validadeMeses;
  final String tipoProjeto;
  final String status;
  final bool temAcompanhamento;
  final DateTime? dataRenovacao;

  Contract copyWith({
    int? id,
    String? nomeCliente,
    DateTime? dataInicio,
    DateTime? dataFim,
    int? validadeMeses,
    String? tipoProjeto,
    String? status,
    bool? temAcompanhamento,
    DateTime? dataRenovacao,
  }) {
    return Contract(
      id: id ?? this.id,
      nomeCliente: nomeCliente ?? this.nomeCliente,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      validadeMeses: validadeMeses ?? this.validadeMeses,
      tipoProjeto: tipoProjeto ?? this.tipoProjeto,
      status: status ?? this.status,
      temAcompanhamento: temAcompanhamento ?? this.temAcompanhamento,
      dataRenovacao: dataRenovacao ?? this.dataRenovacao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_name': nomeCliente,
      'start_date': dataInicio.millisecondsSinceEpoch,
      'end_date': dataFim.millisecondsSinceEpoch,
      'validity_months': validadeMeses,
      'project_type': tipoProjeto,
      'status': status,
      'has_monitoring': temAcompanhamento ? 1 : 0,
      'renewal_date': dataRenovacao?.millisecondsSinceEpoch,
    };
  }

  factory Contract.fromMap(Map<String, dynamic> map) {
    return Contract(
      id: map['id'] as int?,
      nomeCliente: map['client_name'] as String,
      dataInicio: DateTime.fromMillisecondsSinceEpoch(map['start_date'] as int),
      dataFim: DateTime.fromMillisecondsSinceEpoch(map['end_date'] as int),
      validadeMeses: map['validity_months'] as int,
      tipoProjeto: map['project_type'] as String,
      status: map['status'] as String,
      temAcompanhamento: (map['has_monitoring'] as int) == 1,
      dataRenovacao: map['renewal_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['renewal_date'] as int,
            )
          : null,
    );
  }
}

const List<String> kStatusProjeto = <String>[
  'LevantamentoDemanda',      // 1. Levantamento da demanda / Escopo preliminar
  'Proposta',                 // 2. Proposta técnica e comercial
  'Negociacao',               // 3. Negociação e ajustes
  'Assinatura',               // 4. Assinatura do contrato
  'PlanejamentoTecnico',      // 5. Planejamento técnico
  'Execucao',                 // 6. Execução dos serviços ambientais
  'RegistroDocumentacao',     // 7. Registro e documentação
  'EntregaRelatorioFinal',    // 8. Entrega do relatório final
  'ValidacaoCliente',         // 9. Validação com o cliente
  'Encerramento'              // 10. Encerramento
];

const List<String> kTiposProjeto = <String>[
  // Projetos Ambientais
  'LicenciamentoAmbiental',         // Licenciamento de empreendimentos e atividades junto a órgãos ambientais
  'EstudoImpactoAmbiental',         // Estudos de impacto ambiental (EIA/RIMA) para avaliação de projetos
  'MonitoramentoAmbiental',         // Monitoramento de água, solo, fauna, flora e qualidade ambiental
  'GestaoResiduos',                 // Gestão e planejamento de resíduos sólidos e líquidos
  'PlanoRecuperacaoAreaDegradada',  // PRAD – Plano de recuperação de áreas degradadas
  'EducacaoAmbiental',              // Programas e ações de educação e conscientização ambiental
  'SaneamentoAmbiental',            // Projetos de saneamento e tratamento ambiental
  'AuditoriaAmbiental',             // Auditorias e inspeções de conformidade ambiental
  'Geoprocessamento',               // Mapeamento, análise espacial e geoprocessamento de áreas
  'ManejoVegetacao',                // Manejo, supressão e conservação da vegetação
  'AvaliacaoRiscoAmbiental',        // Avaliação de riscos e impactos ambientais
  'ConsultoriaAmbiental',           // Consultoria técnica em questões ambientais

  // Projetos Agronômicos
  'ProjetoIrrigacao',               // Projetos de irrigação e manejo hídrico
  'AnaliseSolo',                    // Análise física e química do solo
  'ManejoSoloAgua',                 // Planejamento e manejo de solo e recursos hídricos
  'ControlePragasDoencas',          // Controle integrado de pragas e doenças em culturas
  'PlanejamentoRural',              // Planejamento e organização de propriedades rurais
  'ExtensaoRural',                  // Atividades de extensão rural e orientação técnica
  'MelhoramentoAgroambiental',      // Projetos de melhoramento e sustentabilidade agroambiental
  'CAR_CadastroAmbientalRural',     // Cadastro Ambiental Rural (CAR)
  'AdequacaoAmbientalPropriedade',  // Adequação ambiental de propriedades rurais
  'ProjetoReflorestamento',         // Projetos de reflorestamento e recuperação florestal
  'PlanoNutricaoPlantas'            // Planejamento de nutrição e fertilização de plantas
];
