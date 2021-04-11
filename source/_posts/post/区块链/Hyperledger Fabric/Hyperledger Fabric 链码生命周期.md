---
title: Hyperledger Fabric 链码生命周期
date: 2021-04-10
tags: []
categories: 
    - 区块链
    - Hyperledger Fabric
---

## Hyperledger Fabric 链码生命周期

链码是实现了规定接口的程序，通常用 Go, Node.js, Java 编写。链码运行在安全的 Docker 容器内，与背书节点进程相隔离。链码通过客户端提交的交易初始化和管理账本状态。

链码通常处理网络成员同意的业务逻辑，因此可以将其视为“智能合约”。通过某个链码创建的账本只能通过这个账本进行更新，不能被其他的链码直接访问。然而，在同一个网络中，在获得正确的许可后，别的链码可以通过调用该链码访问该账本的状态。

在这个主题中，我们将通过区块链网络维护人员的视角，而不是应用程序开发人员的视角来探索链码。

### 部署链码

Fabric 链码的生命周期指的是，多个组织在通道上使用该链码之前，对如何处理链码达成一致意见的过程。一个网络运维人员需要使用 Fabric lifecycle 来完成以下的任务：

- [安装并定义一个链码](https://hyperledger-fabric.readthedocs.io/en/release-2.3/chaincode_lifecycle.html#install-and-define-a-chaincode)
- [升级一个链码](https://hyperledger-fabric.readthedocs.io/en/release-2.3/chaincode_lifecycle.html#upgrade-a-chaincode)
- [部署方案](https://hyperledger-fabric.readthedocs.io/en/release-2.3/chaincode_lifecycle.html#deployment-scenarios)
- [迁移到新的链码生命周期](https://hyperledger-fabric.readthedocs.io/en/release-2.3/chaincode_lifecycle.html#migrate-to-the-new-fabric-lifecycle)

你可以通过新建一个通道，并将通道配置中的 `Capabilities` 设置为 `V2_0` 来使用 `fabric chaincode lifecycle` 命令。如果 `V2_0` 的 `Capabilities` 被打开，那么旧的链码生命周期将无法使用。然而，你仍然可以用以前的链码生命周期模型来调用已经安装了的链码。[链码生命周期迁移教程](https://hyperledger-fabric.readthedocs.io/en/release-2.3/enable_cc_lifecycle.html)。

### 安装并定义一个链码

链码的安装需要组织同意定义链码的参数，比如名字、版本号和链码的背书策略等。通道上的成员需要按照以下的步骤来同意一个链码（不需要每个组织都完成每一步）：

1. 打包链码(package)：这一步可以由一个组织完成，也可以每个组织自己完成；
2. 安装链码到 peers 上(install)：每个要用这个链码来进行交易背书或者查询账本的组织都要完成这一步；
3. 批准组织的链码定义(approve)：每个要用这个链码来进行交易背书或者查询账本的组织都要完成这一步。在链码启动之前，链码的定义需要足够组织的批准来满足链码的生命周期背书策略（ majority 或 default ）；
4. 提交链码的定义到通道上(commit)：一旦通道上所需数量的组织都批准了，提交交易需要由一个组织提交。这个提交组织首先要从已经批准的组织中，收集足够的 Peer 节点背书，然后提交交易，从而提交链码的定义。

本主题详细介绍了Fabric链码生命周期的操作，而不是特定的命令。要了解如何通过 Peer CLI 使用 Fabric 生命周期，请参阅[将智能合约部署到通道教程](https://hyperledger-fabric.readthedocs.io/en/release-2.3/deploy_chaincode.html)或 [peer lifecycle 命令手册](https://hyperledger-fabric.readthedocs.io/en/release-2.3/commands/peerlifecycle.html)。

#### 第一步：智能合约打包

链码必须先打包成 `.tar` 文件，然后才能安装在 Peer 节点上。你可以使用 Fabric Peer 命令，Node Fabric SDK 或第三方工具（例如 GNU tar）来打包链码。打包链码时，需要提供一个**链码包标签**，以创建一个的简洁易读的描述。

如果你使用第三方工具打包链码，则生成的文件需要采用以下格式。 Fabric peer 二进制文件和 Fabric SDKs 将自动创建此格式的文件。

- 链码包需要打包成 `tar` 文件，以 `.tar.gz` 结尾；
- 链码包需要包含两个文件（不是目录）：元数据文件 `metadata.json` 和包含链码文件的 `*.tar.gz` ；
- `metadata.json` 文件包含了链码**使用的语言**、**代码路径**和链码包**标签**。示例如下：

```json
{
    "Path":"fabric-samples/asset-transfer-basic/chaincode-go",
    "Type":"golang",
    "Label":"basicv1"
}
```

![picture 1](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/8fad11d96bc0bf425a43cd30f0963203eb52967ff1141b86176d6e6976944ef6.png)  

链码由 Org1 和 Org2 单独打包。这两个组织都使用 MYCC_1 作为包标签，以便使用名称和版本来标识包。组织无需使用相同的包标签。

#### 第二步：安装链码到 peers 中

每个需要执行交易和为交易背书的 Peer 节点上都要安装链码包。无论是使用 CLI 还是 SDK，你都需要使用 **Peer Admin** 完成此步骤。Peer 节点将在安装链码后构建链码，如果链码出现问题，则返回链码构建错误消息。建议组织只打包一次链码，然后在属于同一个组织的每个 Peer 上安装相同的链码包。如果一个通道想要确保每个组织运行相同的链码，一个组织可以打包一个链码并将其发送给带外的(out of band)的其他通道成员。

安装成功后，将返回一个由包标签与包的哈希组合而成的链码包标识符。此包标识符是用来关联安装在 Peer 上的链码包和组织批准的链码定义的。**该标识符要保存**起来为下一步准备。你还可以通过使用 Peer CLI 查询安装在 Peer 上的包来查找包标识符。

![picture 2](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/20ea2f6a657756c8d8af8353bccf79909b26e95dbaaaa012aa2b8ea548135a0c.png)  

Org1 和 Org2 的 Peer 管理员在加入该通道的 Peer 上安装 MYCC_1 链码包。安装链码包的过程，完成了构建链码和创建包标识符 `MYCC_1:<hashcode>` 的的工作。

#### 第三步：批准组织的链码定义

链码受链码定义的约束。当通道成员批准链码定义时，这个批准的过程，就像组织对链码参数的投票。这些经组织批准定义，可以让通道成员在使用链码之前就达成一致。链码定义包括以下参数，这些参数需要整个组织保持一致：

- `Name` ：应用程序在调用链码时将使用的名称。
- `Version` ：与给定链码包关联的版本编号或值。如果你升级了链码二进制文件，你还需要更改链码版本。
- `Sequence` ：已定义链码的次数。此值是一个整数，用于跟踪链码升级。例如，当你首次安装和批准链码定义时，序列号为 1。下次升级链码时，序列号将增加为 2。
- `Endorsement Policy` ：哪些组织需要执行和验证交易输出。背书策略可以用字符串传递给 CLI ，也可以在通道配置中引用策略。默认情况下，背书策略被设置为 `Channel/Application/Endorsement` ，该背书策略默认要求该通道中的大多数组织为交易背书。
- `Collection Configuration` ：与你的链码关联的私有数据收集定义文件的路径。有关私有数据收集的更多信息，请参阅[私有数据架构手册](https://hyperledger-fabric.readthedocs.io/en/release-2.3/private-data-arch.html)。
- `ESCC/VSCC Plugins` ：此链码将使用的自定义背书或验证插件的名称。
- `Initialization` ：如果你使用 Fabric 链码 Shim API 提供的低级 APIs ，则你的链码需要包含用于初始化链码的 `Init` 函数。链码接口需要此函数，但不一定需要由你的应用程序调用。当你批准链码定义时，你可以指定在 invoke 之前是否必须调用 `Init` 。如果你指定需要 `Init` ， Fabric 将确保在链码中的任何其他函数之前调用 `Init` 函数，并且仅调用一次。执行 `Init` 函数的请求允许你实现在初始化链码时运行的逻辑，例如设置某些初始状态。每次链码版本更新时，你都需要调用 `Init` 来初始化链码，假设版本号增加的链码定义表示需要 `Init` 。

如果你正在使用 Fabric Peer CLI，你可以在批准并提交链码定义时使用 `--init-required` 的标记，以表示必须调用 `Init` 函数来初始化新的链码版本。要使用 Fabric peer CLI 调用 `Init` ，请使用 `peer chaincode invoke` 命令并传入 `--isInit` 标志。

如果你使用的是 Fabric Contract API ，则无需在链码中包含 `Init` 方法。但是，你仍然可以使用 `--init-required` 参数来请求通过应用程序的调用来初始化链码。如果使用 `--init-required` 标志，则每次将链码版本增加时，都需要将 `--isInit` 参数传递给链码调用，以初始化链码。你可以传递 `--isInit` 并使用链码中的任何函数来初始化链码。

链码定义还包括**程序包标识符**。这是每个要使用链码的组织的必需参数。程序包标识符不必对于所有组织都相同。组织可以批准链码定义，而无需安装链码包或在定义中不包含标识符。

每个想要使用链码的通道成员都需要为其组织批准链码定义。该批准需要提交给排序服务，然后再分发给所有 Peer 方。该批准需要由你的组织管理员提交。成功提交批准交易后，批准的定义将存储在一个集合中，该集合可供组织的所有 Peer 方用。因此，即使你有多个 Peer 方，你也只需要为组织批准一次链码。

![picture 3](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/773efc2f61fbfcb4e51ca98bad97f41843741615bba5c7d97e96890e80154069.png)  

Org1 和 Org2 的组织管理员批准其组织的 MYCC 链码定义。链码定义包括链码名称，版本和背书策略以及其他字段。由于两个组织都将使用链码来背书交易，因此两个组织的批准定义都需要包括程序包标识符。

组织可以批准链码定义而不安装链码包。如果组织不需要使用链码，则可以批准不带程序包标识符的链码定义，以确保满足生命周期背书策略。

在将链码定义提交到通道后，链码容器将在已安装链码的所有 Peer 上启动，从而允许通道成员开始使用链码。启动链码容器可能需要几分钟。你可以使用链码定义来要求调用 `Init` 函数来初始化链码。如果请求调用 `Init` 函数，则链码的第一次调用必须是对 `Init` 函数的调用。 `Init` 函数的调用受链码背书策略的约束。

![picture 4](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/1abe222f69c7c7a4be86059a73571645878eeb5fc5ffd5d23d520a3e550ff247.png)  

一旦在通道上定义了 MYCC ， Org1 和 Org2 就可以开始使用链码了。每个 Peer 上的链码的第一次调用都会在该 Peer 上启动链码容器。

### 链码升级

升级链码的过程与安装和启动链码的 Fabric 生命周期相同。你可以升级链码二进制文件，或仅更新链码策略。请按照以下步骤升级链码：

1. 重新打包链码：仅在升级链码二进制文件时才需要完成此步骤。
   ![picture 5](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/3f64011d821ef49bb71bf6a81063b7662f32d21df61293ea81e15760cd869694.png)  
    Org1 和 Org2 升级链码二进制文件并重新打包链码。两家公司使用不同的链码包标签。

2. 在 Peer 上再次安装新的链码软件包：如果要升级链码二进制文件，则仅需要完成此步骤。安装新的链码软件包将生成一个程序包标识符 ，你需要将其传递给新的链码定义。你还需要更改链码版本，生命周期流程将使用它来追踪链码二进制文件，判断是否已升级。
   ![picture 6](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/af2b16ca63944a3cc441c6541065f26696cbfc0f650306005a2750d4611acaf6.png)  
    Org1 和 Org2 在其 Peer 节点上安装新软件包。安装将创建一个新的链码包标识符。

3. 批准新的链码定义：如果要升级链码二进制文件，则需要更新链码定义中的链码版本和程序包标识符。你也可以更新你的链码背书策略，而不必重新打包链码二进制文件。通道成员只需要批准新策略的定义。新定义需要将定义中的序列变量加1。
   ![picture 7](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/77a875649c1a4477dadaca64c2761d7d1ee5c57ae8ec7e336149fde380820587.png)  
    Org1 和 Org2 的组织管理员为各自的组织批准新的链码定义。新定义引用了新的链码包标识符并更改了链码版本。由于这是链码的第一次更新，因此序列从 1 递增到 2 。

4. 将定义提交给通道：当足够数量的通道成员批准了新的链码定义时，一个组织可以提交新定义以将链码定义升级到通道。作为生命周期过程的一部分，没有单独的升级命令。
   ![picture 8](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/f898ab88ed67fafd96f465837b0c60be5d6eb856d6fad376c122b24ef3c37b87.png)  
   来自 Org1 或 Org2 的组织管理员将新的链码定义提交到通道。

提交链码定义后，将使用升级的链码二进制文件中的代码启动新的链码容器。如果在链码定义中请求执行 `Init` 函数，则需要在成功提交新定义后再次调用 `Init` 函数来始化升级的链码。如果在不更改链码版本的情况下更新了链码定义，则链码容器将保持不变，并且不需要调用 `Init` 函数。

![picture 9](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/4864a91eb97ce0828f7a40f9ca1a066ed733f7a033a0a0e95616690d72c09820.png)  

将新定义提交给通道后，每个 Peer 将自动启动新的链码容器。

Fabric 链码生命周期使用链码定义中的 **sequence** 来跟踪升级。所有通道成员都需要将序列号加 1 ，并批准新的定义以升级链码。版本参数用于追踪链码二进制文件，仅在升级链码二进制文件时才需要更改。

### 部署方案

以下示例说明了如何使用 Fabric 链码生命周期来管理通道和链码。

#### 加入通道

新的组织可以使用已定义的链码加入通道，在完成安装链码包和批准已经提交给该通道的链码定义两项工作后，可以开始使用链码。

![picture 10](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/94e7b38589204b052917e10e27fcf88697387fe4c658503eb349c5fa61a196f6.png)  

 org3 加入通道并批准先前由 org1 和 org2 提交给通道的相同链码定义。

批准链码定义后，新组织可以在将​​软件包安装到 Peer 后开始使用链码。该定义不需要再次提交。如果将背书策略设置为要求大多数通道成员进行背书的默认策略，则背书策略将自动更新以囊括新组织。

![picture 11](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/f45cb3b5e2b1423278824c4094b4bef5cc3cd4398985b4569b92ab1299599f95.png)  

链码容器将在 Org3 的 Peer 上首次调用链码后启动。

#### 更新背书策略

你可以使用链码定义来更新背书策略，而不必重新打包或重新安装链码。通道成员可以批准带有新背书策略的链码定义，并将其提交给通道。

![picture 12](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/ef6db262e497c790162d20ef9ad160ea87c5163a608fa8ba1595352945c9077b.png)  

 Org1 ， Org2 和 Org3 批准了一项新的背书策略，要求三个组织全部都背书一项交易。它们将定义中的 sequence 从 1 增加到 2 ，但是不需要更新链码版本。

新的背书策略将在将新定义提交给通道后生效。通道成员不必通过调用链码或执行 `Init` 函数来重新启动链码容器即可更新背书策略。

![picture 13](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/bdb9b29fc8c9bc926ca5b6dc8b02276f03f4d8219000a92476f9d18a80e3fbc9.png)  

一个组织将新的链码定义提交给通道以更新背书策略。

#### 批准定义而不安装链码

你可以批准链码定义而不安装链码包。这使你可以在将链码定义提交到通道之前对其进行背书，即使你不想使用该链码对交易进背书或查询账本。你批准的链码定义要与通道的其他成员拥有相同的参数，但不需要将链码包标识符包含在链码定义中。

![picture 14](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/c124306f2a6971e8798b61aa138fe3221dafa0d37be406a41135d3b7f081bc61.png)  

 Org3 不会安装链码软件包。结果，他们不需要提供链码包标识符作为链码定义的一部分。但是， Org3 仍然可以背书已提交给该频道的 MYCC 的定义。

#### 一个组织不同意链码定义

不批准已提交给通道的链码定义的组织不能使用该链码。未批准链码定义或批准其他链码定义的组织将无法在其 Peer 上执行链码。

![picture 15](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/04965690dafc98426a2ea5e6b9b0cfa3869532833b4e1079332a616d38597e12.png)  

 Org3 批准的链码定义具有与 Org1 和 Org2 不同的背书 策略。结果， Org3 无法在通道上使用 MYCC 链码。但是， Org1 或 Org2 仍然可以获得足够的背书 ，以将定义提交到通道并使用链码。链码中的交易仍将添加到账本中，并存储在 Org3 的 Peer 中。但是， Org3 将无法背书 交易。

组织可以批准具有任何序列号或版本的新链码定义。这使你可以批准已提交给通道的定义并开始使用链码。你也可以批准新的链码定义，以更正在批准或打包链码过程中犯的任何错误。

#### 通道在链码定义上不一致

如果通道上的组织们不同意链码定义，则无法将该定义提交给通道。任何通道成员都将无法使用链码。

![picture 16](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/0e146e68c6e0421ed61b2f30d7f272cdbe3d229cbb5affb971a3022f5c3f4fee.png)  

 Org1 ， Org2 和 Org3 都批准不同的链码定义。结果，该通道的任何成员都无法获得足够的背书以将链码定义提交给该通道。任何通道成员都将无法使用链码。

#### 组织安装不同的链码程序包

每个组织在批准链码定义时都可以使用不同的链码包标识符。这允许通道成员安装使用相同背书策略的不同链码二进制文件，并在同一链码命名空间中读取和写入数据。

组织们可以使用此功能来安装拥有特定业务逻辑的智能合约。每个组织的智能合约都可以包含组织在其 Peer 背书交易之前所需的其他验证。每个组织还可以编写代码，以帮助将智能合约与他们现有系统中的数据集成在一起。

![picture 17](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/02a1f0440f163b70aa09c010aba458b35393fbe65c06622ad0bc3cd88fd6d0ec.png)  

 Org1 和 Org2 每个都安装拥有特定的业务逻辑版本的 MYCC 链码。

#### 使用一个包创建多个链码

你可以使用一个链码包通过批准和提交多个链码定义，在一个通道上创建多个链码实例。每个定义都需要指定一个不同的链码名称。这使你可以在一个通道上运行智能合约的多个实例，但是要让该合约服从不同的背书策略。

![picture 18](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Hyperledger%20Fabric%20%E9%93%BE%E7%A0%81%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F/cff829c1624e7d747b94646b6ea08806bcea31631d022fb3ec54dd97b8a7a33e.png)  

 Org1 和 Org2 使用 MYCC_1 链码包来批准和提交两个不同的链码定义。结果，两个 Peer 都有两个在其 Peer 上运行的链码容器。  MYCC1 的背书策略为两者之一背书，而 MYCC2的背书策略为两者都要背书。

#### 迁移到新的 Fabric 生命周期

有关迁移到新生命周期的信息，请查看[升级到v2.0的注意事项](https://hyperledger-fabric.readthedocs.io/en/release-2.3/upgrade_to_newest_version.html#chaincode-lifecycle)。

如果你需要更新通道配置以启用新的生命周期，请检查[启用新的链码生命周期](https://hyperledger-fabric.readthedocs.io/en/release-2.3/enable_cc_lifecycle.html)。

#### 更多信息

你可以观看[视频](https://youtu.be/XvEMDScFU2M)，以了解有关新Fabric链码生命周期的动机及其实现方式的更多信息。
