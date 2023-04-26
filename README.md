# ShortURL APP

O App ShortURL é um aplicativo construído como um CodingTest a pedido do NuBank.
O app tem como objetivo criar um apelido para alguma URL real, por exemplo:

URL: https://google.com
Apelido: https://localhost/alias/1313

Esse projeto foi desenvolvido em um XCode 12.4 com iOS target 14.4.

## Arquitetura
A arquitetura escolhida para esse projeto foi a [VIP](https://medium.com/@fabio.miciano/arquitetura-ios-vip-4b95f9a0faaa)

### Porque VIP
Visando separação de código, organização e pensando que pode ser um app que escalaria a solução, na minha opinião acredito que seja uma ótima arquitetura que da essa possibilidade e segue o CleanArch.

### Organização de Pastas
Dentro da Arquitetura VIP toda tela é uma **Scene** que contem uma **ViewController**, **Interactor** e **Presenter**, usei essa estrutura para justamente montar as pastas, tenho algo semelhante a ordem abaixo.

 - *Scene*
     - *Views*
     - *Model*
     - **Controller**
     - **Interactor**
     - **Presenter** 

Poderá ser analisado que contem mais arquivos dentro da minha Scene, o porque eu os tenho está um pouco mais explicado no artigo que escrevi, que está no link mais acima.

Também temos pastas para separar toda lógica usada para fazer requests: *Network*.

Pastas para lógica para controlar dados locais: *Local*

Todos os componentes visuais que podem ser reaproveitados ficaram na pasta: *Components*

Algumas lógicas usadas para adicionar Preview do SwiftUI no momento de desenvolvimento ficaram na pasta: *Utils*

E um protocolo criado para ajudar na lifeCicle de criação das views eu criar um protocolo que está na pasta: *Protocols* 

### UI
A metodologia escolhida para criação da interface foi o **ViewCode**
Acredito que o ViewCode da mais poder de reuso de componentes, alem de ser mais rápido de usar que um XIB ou Storyboard.

## Gerenciamento de dependencia

O Gerenciador de dependencias escolhido para o projeto foi o CocoaPods.
Tenho mais costume de uso desse gerenciador e acho muito facil a integração dele com os projetos no XCode.

### PODS
Escolhi alguns Pods para me ajudar na criação do app, abaixo segue a listagem, como uma breve descrição do porque do uso.

**SnapKit:** Usei o SnapKit para ajudar na criação de constraints, poderia ter usado recursos do próprio UIKit, porem acredito que ganhei bons minutos com esse POD.

**SwiftLint:** Usei esse pod somente para analise estática do código para me ajudar a escrever um código mais organizado e fácil de leitura.

**SFFontFeatures:** Esse pod foi usado somente para mudar a fonte padrão do sistema, poderia ter adicionado a fonte da forma padrão, adicionado ela ao info.plist, porem assim ganhei tempo, alem de ser uma fonte da própria Apple.

## UnitTests
Foi adicionado testes unitários em toda camada que eu julgo como camadas de lógica, classes que não possuem interface ou algum import de UIKit.

Acredito que os testes unitários tem que testas a lógica por trás da tela.

## UITests
Foi adicionado testes de UI da tela do app que eu chamei de Home.
Acredito que poderia ser adicionado mais cenários, porem isso envolveria uma evolução de código que vou descrever no próximo tópico.

## Evolução do App
Pensando que isso poderia ser um app que teria continuidade acredito que os proximos passos seriam.

 - Adicionar Botão de Edit na NavigationBar
     - Dar a possibilidade de editar o alias ou deletar a URL
 - Aumentar o numero de testes de interface
 - Mockar o backend para testes de interface para ter testes de UI e não testes integrados.
 - Dar a opção de abrira URL em uma WebView ao ser tocada
 - Adicionar Acessibilidade


## Dificuldades
A escolha dos Pods e de deixar alguns itens para evolução do app foi devido a algumas dificuldades técnicas.

Estou com um Mac 2012 como XCode12, devido a sua idade é uma maquina que roda bem lenta com simulador tendo vários problemas, por isso optei pelos PODS listados acima para me dar velocidade no desenvolvimento.
