Olá! Este projeto é um aplicativo de gerenciamento de tarefas desenvolvido em Flutter 3.24.

O app oferece funcionalidades para criar, editar, excluir, concluir e priorizar tarefas, além de definir lembretes para tarefas com data de vencimento próxima.

## Arquitetura

A arquitetura segue o padrão MVVM, com Repository Pattern na camada de dados, garantindo uma estrutura modular e fácil de manter.

O **Repository Pattern** atua como uma interface entre as fontes de dados e as demais camadas, centralizando o acesso em _repositórios_. Isso organiza o código, facilita testes e manutenção e permite trocar fontes de dados sem afetar a aplicação.

## Tecnologias e Ferramentas

- **Riverpod**: Gerencia estados complexos de forma escalável, proporcionando uma experiência reativa e eficiente.
- **Flutter Hooks**: Simplifica o gerenciamento de estados básicos, trazendo clareza ao código.
- **Go Router**: Utilizado para navegação com type safety por meio do go router builder.
- **Shared Preferences**: Para armazenamento local de dados das tarefas.
- **Flutter Local Notifications Plugin**: Implementa lembretes para as tarefas (veja a classe `NotificationService`).
- **Json Annotation e Json Serializable**: Para serialização e desserialização de dados.
- **Mocktail**: Utilizado para testes unitários, garantindo a qualidade do código.

## Demonstração em Vídeo

https://github.com/user-attachments/assets/d4cb1525-5f67-41ec-9186-30601824b331

(Veja até o final para ver o reminder em ação!)
