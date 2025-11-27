## Cadastro de Contratos

Aplicativo Flutter simples para cadastrar e acompanhar contratos de projetos usando um banco de dados local (SQLite).

### Principais recursos
- Lista em formato de grid com nome, datas de inicio/fim, validade em meses, tipo, status e (quando aplicavel) data de renovacao.
- Acoes por cartao: alterar ou excluir.
- Tela dedicada para cadastrar/editar contratos com selecao de datas, dropdowns para tipo/status e controle para habilitar a renovacao.
- Persistencia local via `sqflite`, com repositorio e controller para desacoplar a UI da camada de dados.

### Como executar
1. Certifique-se de ter o Flutter SDK instalado e disponivel no `PATH`.
2. (Opcional, mas recomendado neste repositorio vazio) execute `flutter create .` uma unica vez para gerar as pastas de cada plataforma. Os arquivos em `lib/` nao serao sobrescritos.
3. Rode `flutter pub get` para baixar as dependencias.
4. Inicie o app em um emulador/dispositivo com `flutter run`.

### Estrutura
```
lib/
 |- controllers/ ... controller e estado global
 |- data/ ... helper do SQLite e repositorio
 |- models/ ... modelo Contract + constantes
 |- pages/
 |   |- contract_form_page.dart
 |   |- contract_list_page.dart
 |- utils/ ... helpers de formatacao
 |- widgets/ ... cartao reutilizavel para a lista
```