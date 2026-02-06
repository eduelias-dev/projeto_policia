# MVP - Registro de Ocorrências Offline

## 📋 Descrição

Aplicação Flutter para registro de ocorrências offline na Polícia Científica. O aplicativo permite registrar, visualizar e gerenciar ocorrências com persistência local usando SQLite.

## 🏗️ Arquitetura

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/
│   └── ocorrencias.dart     # Modelo de dados Ocorrencia
├── database/
│   └── database_helper.dart # Gerenciador do SQLite (Singleton)
├── cubit/
│   ├── ocorrencia_cubit.dart    # Lógica de estado (BLoC)
│   └── ocorrencia_state.dart    # Estados possíveis
└── pages/
    └── home_page.dart       # Tela principal
```

## 🛠️ Tecnologias Utilizadas

### Gerenciamento de Estado
- **flutter_bloc (Cubit)**: Padrão recomendado para aplicações governamentais
- **equatable**: Para comparação de objetos nos estados

### Persistência de Dados
- **sqflite**: Banco de dados SQLite para Flutter
- **path**: Para gerenciar caminhos de arquivos

### Utilitários
- **intl**: Para formatação de datas

## 📦 Dependências

```yaml
dependencies:
  flutter_bloc: ^9.0.0
  bloc: ^9.0.0
  equatable: ^2.0.5
  sqflite: ^2.3.0
  path: ^1.9.0
  intl: ^0.20.0
```

## 🚀 Como Executar

1. **Instale as dependências:**
```bash
flutter pub get
```

2. **Execute a aplicação:**
```bash
flutter run
```

## 📝 Estrutura de Dados

### Modelo: Ocorrencia
```dart
class Ocorrencia {
  final int? id;           // ID gerado automaticamente pelo SQLite
  final String titulo;     // Título da ocorrência (máx 100 chars)
  final String descricao;  // Descrição detalhada (máx 500 chars)
  final String data;       // Data e hora do registro (formato: dd/MM/yyyy HH:mm)
}
```

### Tabela SQLite
```sql
CREATE TABLE ocorrencias (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  titulo TEXT NOT NULL,
  descricao TEXT NOT NULL,
  data TEXT NOT NULL
)
```

## 🧩 Componentes Principais

### 1. DatabaseHelper (database_helper.dart)
Classe **Singleton** responsável por todas as operações com o banco de dados.

**Métodos públicos:**
- `insertOcorrencia(Ocorrencia)` - Insere uma nova ocorrência
- `fetchOcorrencias()` - Retorna todas as ocorrências ordenadas por ID (descendente)
- `getOcorrenciaById(int id)` - Busca uma ocorrência específica
- `updateOcorrencia(Ocorrencia)` - Atualiza uma ocorrência existente
- `deleteOcorrencia(int id)` - Deleta uma ocorrência
- `deleteAllOcorrencias()` - Limpa todas as ocorrências

**Boas práticas implementadas:**
- ✅ Singleton pattern para evitar múltiplas conexões
- ✅ Tratamento de erros com try-catch
- ✅ Lazy initialization do banco de dados
- ✅ Validação de dados antes de operações

### 2. OcorrenciaCubit (ocorrencia_cubit.dart)
Gerencia o estado das ocorrências usando o padrão Cubit do BLoC.

**Métodos públicos:**
- `carregarOcorrencias()` - Carrega todas as ocorrências do banco
- `adicionarOcorrencia(titulo, descricao)` - Adiciona uma nova ocorrência
- `deletarOcorrencia(id)` - Deleta uma ocorrência
- `atualizarOcorrencia(id, titulo, descricao)` - Atualiza uma ocorrência

**Estados emitidos:**
- `OcorrenciaInitial` - Estado inicial
- `OcorrenciaLoading` - Durante operações assíncronas
- `OcorrenciaLoaded` - Sucesso com lista de ocorrências
- `OcorrenciaError` - Erro com mensagem descritiva

### 3. MainPage (home_page.dart)
Interface principal da aplicação com BlocBuilder para reatividade.

**Funcionalidades:**
- 📋 Lista de ocorrências em ListView
- ➕ FloatingActionButton para adicionar ocorrências
- 🗑️ Opção de deletar ocorrências com confirmação
- 📱 BottomSheet para formulário de entrada
- 💬 SnackBars para feedback ao usuário

## 🎯 Fluxo de Operações

### Adicionar Ocorrência
1. Usuário clica no FloatingActionButton
2. BottomSheet abre com formulário
3. Usuário preenche Título e Descrição
4. Ao clicar "Salvar":
   - Validação dos campos
   - `OcorrenciaCubit.adicionarOcorrencia()` é chamado
   - Estado muda para `OcorrenciaLoading`
   - Ocorrência é inserida no SQLite via `DatabaseHelper`
   - Cubit recarrega a lista automaticamente
   - Estado muda para `OcorrenciaLoaded`
   - UI é atualizada com o BlocBuilder

### Deletar Ocorrência
1. Usuário clica no ícone de lixeira
2. Dialog de confirmação aparece
3. Ao confirmar:
   - `OcorrenciaCubit.deletarOcorrencia()` é chamado
   - Ocorrência é removida do SQLite
   - Lista é recarregada automaticamente
   - UI é atualizada

## 🔒 Offline First

O aplicativo foi projetado para funcionar completamente offline:
- ✅ Todos os dados são armazenados localmente no SQLite
- ✅ Nenhuma dependência de conexão com internet
- ✅ Dados persistem mesmo após fechar o app
- ✅ Pronto para sincronização futura com servidor

## 📚 Boas Práticas Implementadas

1. **Separação de Responsabilidades**: Cada classe tem uma única responsabilidade
2. **SOLID Principles**: Especialmente Single Responsibility
3. **Error Handling**: Tratamento de exceções em operações assíncronas
4. **State Management**: Padrão BLoC com Cubit para gerência reativa
5. **Code Organization**: Estrutura de pasta clara e escalável
6. **Comments**: Comentários explicativos em pontos-chave
7. **Type Safety**: Uso de tipos específicos em vez de dynamic
8. **Resource Management**: Disposal apropriado de controllers

## 🔧 Próximos Passos (Melhorias Futuras)

1. **Sincronização com servidor** - Implementar upload quando houver internet
2. **Autenticação** - Adicionar login de usuário
3. **Busca e Filtros** - Permitir filtrar ocorrências por data, título, etc.
4. **Edição** - Permitir editar ocorrências existentes
5. **Categorias** - Adicionar categorias de ocorrência
6. **Assinatura Digital** - Validação com assinatura eletrônica
7. **Testes Automatizados** - Unit tests e widget tests
8. **Notificações** - Sistema de lembretes e notificações

## 📞 Suporte

Para dúvidas sobre a implementação, consulte os comentários no código ou refira-se à documentação:
- [Flutter BLoC](https://bloclibrary.dev/)
- [SQLFlite](https://pub.dev/packages/sqflite)
- [Flutter Documentation](https://flutter.dev/docs)

---

**Desenvolvido para a Polícia Científica - MVP 2026**
