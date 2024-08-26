---
title: Fabric CA部署过程
tags: []
categories:
  - article
  - 计算机
  - 区块链
  - Hyperledger Fabric
date: 2021-04-05 00:00:00
---

## Fabric CA 部署过程

### 下载二进制文件

这些二进制文件中，您可能想改用 Fabric CA 映像，例如在 Kubernetes 或 Docker 部署。不过，到目前为止，本主题的目的是教您如何正确使用二进制文件。服务器和 CA 客户端二进制文件。掌握了使用部署和运行 CA 之后 Fabric CA 服务器和 CA 客户端二进制文件可以从 github 下载。向下滚动到 Assets ，然后为您的计算机类型选择最新的二进制文件。 .zip 文件包含两个 CA 。

#### 服务器二进制文件

在本主题中，我们使用服务器二进制文件来部署三种不同类型的 CA：TLS CA ，组织 CA ，以及可选的中间 CA 。 TLS CA 颁发安全的证书在组织中的所有节点之间进行通信。组织 CA 颁发身份证书。如果您决定包括一个中间 CA ，则组织 CA 将充当根 CA 规划 CA 以了解每种类型的 CA 的目的及其差异。我们跑 CA 或中间 CA 的父服务器。如果您还没有，请查看该主题 TLS CA ，组织 CA 和来自不同文件夹的中间 CAS 。我们将 CA 服务器二进制文件复制到每个文件夹。

#### 客户端二进制文件

同样，我们将 Fabric CA 客户端二进制文件复制到其自己的目录中。将 CA 客户端放在其自己的文件夹中可简化证书管理，尤其是当您需要与多个 CA 进行交互时。当您从 CA 客户端向 CA 服务器发出命令时，可以通过修改请求中的 CA 服务器 URL 来定位特定的 CA 。因此，仅需要单个 Fabric CA client 二进制文件，即可用于与多个 CA 进行事务处理。有关在下面使用 Fabric CA 客户端的更多信息。

### Fabric CA 客户端

在部署 Fabric CA 服务器之前，您需要了解 Fabric CA 客户端的角色。Fabric CA 客户本主题假定正在使用单个 Fabric CA 客户端。注册身份或用户是使用 LDAP 服务器进行用户注册，则不需要注册步骤，因为将注册 ID 和机密添加到 CA 数据库“用户注册表”的过程。如果你是虽然可以使用 Fabric SDK 与 CA 进行交互，但建议您使用 Fabric CA 客户端注册和注册节点管理员身 ​​ 份。在此提供的说明 LDAP 数据库中已经存在身份。注册用户后，您可以使用结构需要作为组织的一部分进行交易。当您提交注册请求时， CA 客户端“注册”身份，该身份是生成证书的过程由于您将使用单个 CA 客户端向多个 CA 提交注册和注册请求，因此在使用 CA 客户端时，证书管理至关重要。最佳做法专用和公用密钥首先由 Fabric CA 客户端在本地生成，然后将公用密钥发送到 CA ， CA 返回编码的“签名证书”。因此，将为 CA 客户端将与之交互的每个 CA 服务器创建子文件夹，以存储生成的证书。

由于您将使用单个 CA 客户端向多个 CA 提交注册和注册请求，因此在使用 CA 客户端时，证书管理至关重要。最佳做法因此，将为 CA 客户端将与之交互的每个 CA 服务器创建子文件夹，以存储生成的证书。

- 创建一个子文件夹以连接到每个 CA 服务器，例如 `/tls-ca` 或， `/orgl.ca` 或。该文件夹可以在 Fabric CA 客户端下，也可以在 CA 客户端可以访问的任何位置下 `/int-ca` 访问路径。出于这些说明的目的，这些文件夹位于 `fabric-ca-client` 目录内。例如：

```BASH
mkdir fabric-ca-client
cd fabric-ca-client
mkdir tls-ca org1-ca int-ca
```

提示：虽然您可以从任何首选的文件夹中运行 Fabric CA 客户端二进制文件，但为了方便起见，在遵循这些说明时，我们将在其自己的目录中对其进行引用按客户要求的结构。

SSL 握手。名为的 TLS CA 根证书在 TLS CA 上生成客户端与服务器之间的通信。例如，当 Fabric CA 客户端发出注册或向 CA 服务器注册请求，客户端请求包括该根证书以执行客户结构将 Fabric CA 客户端二进制文件复制到该文件夹 ​​ 中。

- 将 Fabric CA 客户端二进制文件复制到 `fabric-ca-client` 文件夹中。
- 因为在生产网络上启用了 TLS 通信，所以组织的 TLS CA 负责生成证书，以保护组织中所有节点之间的通信安全。因此， Fabric CA 客户端每次与该组织中的 CA 服务器进行交易时，都需要提供 TLS CA “根证书”以保护 `ca-cert.pem` ，在服务器配置 `.yaml` 文件中启用 TLS 之后。要为您的 CA 客户端启用 TLS 通信，您需要一个子文件夹来存储`tls-root-cert` 。在本主题的稍后部分，我们将把根证书复制到该文件夹 ​​ 中。

```BASH
mkdir tls-root-cert
```

产生的文件夹结构类似于：

```code
fabric-ca-client
  ├── int-ca
  ├── org1-ca
  ├── tls-ca
  └── tls-root-cert
```

重要提示：如果您的 Fabric CA 客户端将与来自受不同 TLS 服务器保护的多个组织的 CAS 进行交易，则您将需要创建不同的 `tls-root-cert` 文件夹来保存每个组织的 TLS CA 根证书，或者在内部简单地命名不同文件夹以区分它们。
由于我们的 Fabric CA 客户端将仅与同一组织中的 CA 服务器进行事务处理，而所有这些服务器均由相同的 TLS CA 保护，因此我们在此文件夹中将只有一个根证书。

您可以在 CLI 命令上使用环境变量或标志来指定证书和 Fabric CA 客户端二进制文件的位置：

- `FABRIC_CA_CLIENT_HOME` ：指定 Fabric CA 客户端二进制文件所在的标准路径。
- `FABRIC_CA_CLIENT_TLS_CERTFILES` ：指定 TLS CA 根证书的位置和名称。如果环境变量 `FABRIC_CA_CLIENT_TLS_CERTFILES` 的路径不是绝对路径，则将其解析为相对于 `FABRIC_CA_CLIENT_HOME` 指定的 Fabric CA 客户端主目录的相对路径。在这些说明中，我们在命令上使用 `--tls.certfiles` 标志，而不是指定 TLS CA 根证书的位置。
- `FABRIC_CA_CLIENT_MSPDIR` ：尽管您可以使用此环境变量来指定证书所在的文件夹的名称，但是由于客户端与多个 CA 进行通信，所以更好的选择是在 register 上显式传递 `--mspdir` 标志，并注册命令以指定位置。如果未在命令上指定，则该位置默认为 `$FABRIC_CA_CLIENT_HOME/msp` ，如果 Fabric CA 客户端与组织中的多个 CA 服务器进行交易，则该位置将成问题。

提示：第一次从 CA 客户端发出 `enroll` 命令时，如果 `$FABRIC_CA_CLIENT_HOME` 目录中尚不存在 `fabric-ca-client-config.yaml` ，则会生成该命令。当您自定义此文件中的值时， CA 客户端会自动使用它们，而不必在后续的 `enroll` 命令中在命令行中传递它们。

在这些说明中，始终使用单个 Fabric CA 客户端与多个 CA 服务器进行交互，但这不一定是必需的模式。另一种选择是为每个 CA 服务器使用单个 Fabric CA 客户端。在这种情况下，当为 CA 服务器管理员发出初始注册命令时，将生成到服务器的 Fabric CA 客户端连接设置，并将其存储在 `fabric-ca-client-config.yaml` 文件中。

### 从 CLI 提交事务

CA 服务器和 CA 客户端二进制文件随附了两组 CLI 命令：

- 使用 Fabric CA 服务器 CLI 命令来部署和更新 CA 服务器。
- 设置后，使用 Fabric CA 客户端 CLI 命令将请求提交到您的 CA 服务器，例如注册，注册或吊销身份。

在本主题中，我们将同时使用这两个 CLI 命令。

### 我应该按什么顺序部署 CA ？

假设您将不部署同时包含 TLS CA 和组织 CA 的双头 CA ，则可以按以下顺序部署 CA ：

1. 部署 TLS CA
   由于生产网络中需要 TLS 通信，因此必须在每个 CA，对等方和订购节点上启用 TLS。尽管《 CA Operations 指南》中的示例配置在所有组织中共享一个 TLS CA，但建议的生产配置是为每个组织部署 TLSCA。 TLS CA 颁发 TLS 证书，以确保网络上所有节点之间的通信安全。因此，需要首先对其进行部署以为节点之间发生的 TLS 握手生成 TLS 证书。

2. 部署组织 CA
   这是组织的身份注册 CA ，用于注册和注册将要从该组织参与网络的身份。

3. 部署中间 CA （可选）
   如果您决定在网络中包括中间 CA，则必须先部署中间 CA 的父服务器（关联的根 CA ），然后再部署任何中间 CA 。

### 部署 TLS CA

无论您是设置 TLS CA ，组织 CA 还是中间 CA ，该过程都遵循相同的总体步骤。区别在于您对 CA 服务器配置 .yaml 文件所做的修改。以下步骤概述了该过程：

1. 初始化 CA 服务器
2. 修改 CA 服务器配置
3. 删除 CA 服务器证书
4. 启动 CA 服务器
5. 使用 TLS CA 注册引导用户

部署任何节点时， TLS 配置都有三个选项：

- 没有 TLS。不建议用于生产网络。
- 服务器端 TLS。
- 相互 TLS。

此过程将配置一个启用了服务器端 TLS 的 CA ，推荐用于生产网络。默认情况下，相互 TLS 是禁用的。如果需要使用双向 TLS ，请参考 TLS 配置设置。

#### 在你开始之前

您应该已经下载了 Fabric CA 服务器二进制文件 `fabric-ca-server` 并将其复制到计算机上的干净目录中。出于这些说明的目的，我们将二进制文件放入其自己的名为 `fabric-ca-server-tls` 的文件夹中。

```BASH
mkdir fabric-ca-server-tls
```

将 `fabric-ca-server` 二进制文件复制到此文件夹中。

#### 初始化 TLS CA 服务器

部署 CA 服务器的第一步是对其进行“初始化”。通过指定 CA 的管理员用户 ID 和密码，运行以下 CA Server CLI 命令以初始化服务器：

```BASH
./fabric-ca-server init -b <ADMIN_USER>:<ADMIN_PWD>
```

例如：

```BASH
cd fabric-ca-server-tls
./fabric-ca-server init -b tls-admin:tls-adminpw
```

`-b` （引导程序身份）标志将管理员用户名和密码引导至 CA 服务器，该服务器名有效地为您向服务器“注册”了 CA admin 用户，因此引导用户不需要显式的 Fabric CA 客户端 CLI 册命令。除了使用 `-b` 标志隐式注册的该 CA 管理员身份外，所有 CA 用户都需要先“注册”然后再“注册”到 CA 。注册过程会将用户插入到 CA 数据库中。当将配置 LDAP 时，不需要 `-b` 选项进行初始化。

注意：此示例仅用于说明目的。显然，在生产环境中，您永远不会使用 `tls-admin` 和 `tls-adminpw` 作为引导程序用户名和密码。确保记录了您指定的管理员 ID 和密码。稍后当您向 CA 发出注册和注册命令时，它们是必需的。使用有意义的 ID 可以帮助您区分与哪个服务器进行交易并遵循安全密码惯例。

#### CA 服务器初始化命令有什么作用？

`init` 命令实际上不会启动服务器，但是会生成所需的元数据（如果该元数据对于服务器而言尚不存在）：

- 将默认的 CA Home 目录（在这些说明中称为 `FABRIC_CA_HOME` ）设置为运行 `fabric-ca-server init` 命令的位置。
- 生成默认配置文件 `fabric-ca-server-config.yaml` ，该文件用作 `FABRIC_CA_HOME` 目录中服务器配置的模板。在整个说明中，我们将此文件称为“ configuration .yaml”文件。
- 创建 TLS CA 根签名证书文件 `ca-cert.pem`（如果它在 CA Home 目录中尚不存在）。这是自签名的根证书，这意味着它是由 TLS CA 本身生成和签名的，而不是来自其他来源。该证书是必须与要与组织中的任何节点进行交易的所有客户端共享的公用密钥。当任何客户端或节点向另一个节点提交事务时，它必须将此证书作为事务的一部分。
- 生成 CA 服务器私钥，并将其存储在 `/msp /keystore` 下的 `FABRIC_CA_HOME` 目录中。
- 初始化服务器的默认 SQLite 数据库，尽管您可以修改配置.yaml 文件中的数据库设置以使用您选择的支持的数据库。每次启动服务器时，它将从该数据库加载数据。如果您稍后切换到其他数据库（例如 PostgreSQL 或 MySQL ），并且配置 .yaml 文件的 `registry.identites` 部分中定义的身份在该数据库中不存在，则将对其进行注册。
- 将由 `-b` 标志参数 `<ADMIN_USER>` 和 `<ADMIN_PWD>` 指定的 CA 服务器管理员引导到服务器上。随后启动 CA 服务器时，将使用配置 .yaml 文件 `registry` 部分中提供的 admin 属性来注册 admin 用户。如果此 CA 将用于注册具有这些属性中任何一个的其他用户，则 CA 管理员用户需要拥有这些属性。换句话说，注册服务商必须具有 `hf.Registrar.Roles` 属性，然后才能使用这些属性中的任何一个注册另一个身份。因此，如果此 CA 管理员将用于注册中级 CA 的管理员身份，则即使该 CA 可能不是中级 CA 服务器，该 CA 管理员也必须将 `hf.IntermediateCA` 设置为 `true` 。默认设置已包含这些属性。

重要说明：在配置 .yaml 文件中修改设置并重新启动服务器时，不会替换以前颁发的证书。如果要在启动服务器时重新生成证书，则需要删除它们并运行 `fabric-ca-server start` 命令。例如，如果在启动服务器后修改 `csr` 值，则需要删除以前生成的证书，然后运行 `fabric-ca-server start` 命令。但是请注意，当您使用新的签名证书和私钥重新启动 CA 服务器时，所有以前颁发的证书将不再能够通过 CA 进行身份验证。

#### 修改 TLS CA 服务器配置

现在，您已经初始化了服务器，您可以根据生产 CA 服务器的清单，编辑生成的 `fabric-ca-server-config.yaml` 文件，以修改用例的默认配置设置。

至少应执行以下操作：

- `port` - 输入要用于此服务器的端口。这些说明使用 7054 ，但是您可以选择端口。
- `tls.enabled` - 回忆默认配置文件中禁用了 TLS 。由于这是生产服务器，因此可以通过将该值设置为 `true` 来启用它。将此值设置为 `true` 会导致在下一步中启动服务器时生成 TLS 签名证书 `tls-cert.pem` 文件。 `tls-cert.pem` 是服务器在 TLS 握手期间将提供给客户端的证书，然后客户端将使用 TLS CA 的 `ca-cert.pem` 对其进行验证。
- `ca.name` - 通过编辑参数为 CA 命名，例如 `tls-ca` 。
- `csr.hosts` - 更新此参数以包括此服务器运行所在的主机名和 IP 地址（如果此文件中已存在的主机名和 IP 地址不同）。
- `signing.profiles.ca` - 由于这是不会颁发 CA 证书的 TLS CA ，因此可以删除“ ca 个人资料”部分。 `signing.profiles` 块应仅包含 `tls` 配置文件。
- `Operations.listenAddress:`-在不太可能的情况下，该主机和端口上正在运行另一个节点，那么您需要更新此参数以使用其他端口。

#### 删除 TLS CA 服务器证书

启动服务器之前，如果您修改了配置 .yaml 文件的 csr 块中的任何值，则需要删除 `fabric-ca-server-tls/ca-cert.pem` 文件和整个 fabric-ca-server `-tls/msp` 文件夹。在下一步中启动 CA 服务器时，将重新生成这些证书。

#### 启动 TLS CA 服务器

运行以下命令以启动 CA 服务器：

```BASH
./fabric-ca-server start
```

服务器成功启动后，您将看到类似以下内容的内容：

```code
[INFO] Listening on https://0.0.0.0:7054
```

因为您已启用 TLS 通信，所以请注意 TLS 签名证书 `tls-cert.pem` 文件是在 `FABRIC_CA_HOME` 位置下生成的。

提示：在 `init` 命令上设置的 CA `ADMIN_USER` 和 `ADMIN_PWD` 不能用 `start` 命令上的 `-b` 标志覆盖。当您需要修改 CA 管理员密码时，请使用 Fabric CA 客户端身份命令。

可选标志：

- `-d` - 如果要在调试模式下运行服务器（这有助于问题诊断），则可以在启动命令中包括 `-d` 标志。但是，通常不建议在启用调试的情况下运行服务器，因为这将导致服务器性能降低。
- `-p` - 如果希望服务器在与配置 .yaml 文件中指定的端口不同的端口上运行，则可以覆盖现有端口。

#### 使用 TLS CA 注册引导程序用户

既然已经配置了 TLS CA ，并且可以为组织部署任何其他节点，则需要注册 TLS CA 的引导（管理员）用户。由于 CA 服务器已启动并正在运行，因此现在不再使用 Fabric CA 服务器 CLI 命令，而是使用 Fabric CA 客户端 CLI 命令向服务器提交注册请求。

通过使用 Fabric CA 客户端执行，注册过程将用于生成形成节点身份的证书和私钥对。您应该已经在 Fabric CA 客户端部分中设置了所需的文件夹。

我们用于这些 Fabric CA 客户端命令的文件夹结构为：

```code
fabric-ca-client
  └── tls-ca
  └── tls-root-cert
```

Fabric CA 客户端将这些文件夹用于：

- 存储对 TLS CA 服务器运行 Fabric CA client enroll 命令以注册 TLS CA 引导程序标识时颁发的证书。 （ tls-ca 文件夹）
- 知道 TLS CA 根证书所在的位置，该证书允许 Fabric CA 客户端与 TLS CA 服务器进行通信。 （ tls-root-cert 文件夹）

1. 将启动 TLS CA 服务器时生成的 TLS CA 根证书文件 `fabric-ca-server-tls/ca-cert.pem` 复制到 `fabric-ca-client/tls-root-cert/tls-ca- cert.pem` 文件夹。请注意，文件名已更改为 `tls-ca-cert.pem` ，以使其清楚这是来自 TLS CA 的根证书。重要说明： TLS CA 根证书必须在每个针对 TLS CA 运行命令的客户端系统上都可用。
2. Fabric CA 客户端还需要知道 Fabric CA 客户端二进制文件的位置。 `FABRIC_CA_CLIENT_HOME` 环境变量用于设置位置。

   ```code
   export FABRIC_CA_CLIENT_HOME=<FULLY-QUALIFIED-PATH-TO-FABRIC-CA-BINARY>
   ```

   例如，如果您位于 `fabric-ca-client` 文件夹中，则可以使用：

   ```code
   export FABRIC_CA_CLIENT_HOME=$PWD
   ```

3. 您已准备好使用 Fabric CA 客户端 CLI 注册 TLS CA 管理员用户。运行命令：

```code
./fabric-ca-client enroll -d -u https://<ADMIN>:<ADMIN-PWD>@<CA-URL>:<PORT> --tls.certfiles <RELATIVE-PATH-TO-TLS-CERT> --enrollment.profile tls --csr.hosts '<CA_HOSTNAME>' --mspdir tls-ca/tlsadmin/msp
```

- `<ADMIN>` - 使用 `init` 命令中指定的 TLS CA 管理员。
- `<ADMIN-PWD>` - 使用 `init` 命令中指定的 TLS CA 管理员密码。
- `<CA-URL>` - 使用在 TLS CA 配置.yaml 文件的 `csr` 部分中指定的主机名。
- `<PORT>` - 使用 TLS CA 正在侦听的端口。
- `<RELATIVE-PATH-TO-TLS-CERT>` - 带有从 TLS CA 复制的根 TLS 证书文件的路径和名称。此路径是相对于 `FABRIC_CA_CLIENT_HOME` 的。如果您遵循本教程中的文件夹结构，则为 `tls-root-cert/tls-ca-cert.pem` 。
- `<CA_HOSTNAME>` - 带有逗号分隔的证书名称的主机名列表。如果未指定，则使用 `fabric-ca-client-config.yaml` 中的默认值。您可以为域指定一个通配符。例如，当包含标志 `--csr.hosts'host1，*。example.com'` 时，意味着主机名 `host1` 以及 `example.com` 域中的任何主机均被识别。这些值将插入到生成的证书使用者备用名称（ SAN ）属性中。此处指定的值对应于您为 CA 服务器指定的 `csr.hosts` 参数。

例如：

```code
./fabric-ca-client enroll -d -u https://tls-admin:tls-adminpw@my-machine.example.com:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'host1,*.example.com' --mspdir tls-ca/tlsadmin/msp
```

在这种情况下， `-d` 参数以 DEBUG 模式运行客户端，这对于调试注册失败很有用。

请注意，在命令上使用了 `--mspdir` 标志，以指定在哪里存储由 enroll 命令生成的 TLS CA 管理员证书。

之所以指定 `--enrollment.profile tls` 标志，是因为我们正在针对 TLS CA 进行注册。使用此标志意味着注册是根据配置 .yaml 文件的 `signing` 部分中定义的 TLS 配置文件的 `usage` 和 `expiry` 设置执行的。**注意：**如果从 TLS CA 配置 .yaml 文件中删除了 `signing.profiles.ca` 块，则可以省略 `--enrollment.profile tls` 标志。

成功完成此命令后，将生成 `fabric-ca-client/tls-ca/tlsadmin/msp` 文件夹，其中包含 TLS CA 管理员身份的签名证书和私钥。如果 enroll 命令由于某种原因而失败，为了避免以后造成混淆，您应该在重新尝试 enroll 命令之前从 `fabric-ca-client/tls-ca/admin/msp/keystore` 文件夹中删除生成的私钥。当需要在 TLS CA 中注册其他身份时，我们将在以后引用此加密材料。

提示：从 Fabric CA 客户端发出此第一个 `enroll` 命令后，检查生成的 `fabric-ca-client/fabric-ca-client-config.yaml` 文件的内容，以熟悉 Fabric 使用的默认设置。 CA 客户端。因为我们使用单个 Fabric CA 客户端与多个 CA 服务器进行交互，所以我们需要在客户端 CLI 命令上使用 `-u` 标志来定位正确的 CA 服务器。 `--mspdir` 标志指示在 `register` 命令上使用的加密材料的位置，或在 `enroll` 命令上存储生成的证书的位置。

下图是您创建 TLS CA 服务器并使用 Fabric CA 客户端注册引导程序标识所执行的步骤的概念性摘要：

![picture 1](../../../../assets/%E5%8C%BA%E5%9D%97%E9%93%BE/Hyperledger%20Fabric/Fabric%20CA%E9%83%A8%E7%BD%B2%E8%BF%87%E7%A8%8B/92e199190128e0a4397f93fcc76cb491e1248f77d7d310f4c34729346f0bc047.png)

#### 使用 TLS CA 注册并注册组织 CA 引导程序标识

TLS CA 服务器以引导程序身份启动，该身份具有服务器的完全管理员特权。管理员的关键能力之一是注册新身份的能力。组织中在网络上进行交易的每个节点都需要向 TLS CA 注册。因此，在设置组织 CA 之前，我们需要使用 TLS CA 来注册和注册组织 CA 引导程序标识，以获取其 TLS 证书和私钥。以下命令将组织 CA 引导程序身份 `rcaadmin` 和 `rcaadminpw` 注册到 TLS CA。

```code
./fabric-ca-client register -d --id.name rcaadmin --id.secret rcaadminpw -u https://my-machine.example.com:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp
```

请注意，命令上的 `--mspdir` 标志指向我们在上一步中生成的 TLS CA admin msp 证书的位置。需要使用这种加密材料才能向 TLS CA 注册其他用户。

接下来，我们需要注册 `rcaadmin` 用户以为该身份生成 TLS 证书。在这种情况下，我们在 enroll 命令上使用 `--mspdir` 标志来指定应为 `rcaadmin` 用户存储生成的组织 CA TLS 证书的位置。因为这些证书具有不同的身份，所以最佳做法是将它们放在自己的文件夹中。因此，我们将它们放置在 `tlsadmin` 文件夹旁边，而不是将它们放置在默认的 `msp` 文件夹中，而不是将其放置在名为 `rcaadmin` 的新文件夹中。

```BASH
./fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@my-machine.example.com:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'host1,*.example.com' --mspdir tls-ca/rcaadmin/msp
```

在这种情况下，`--mspdir` 标志的工作原理略有不同。对于 `enroll` 命令，`--mspdir` 标志指示将生成的证书用于 `rcaadmin` 身份的存储位置。

重要提示：组织 CA TLS 签名证书是在 `fabric-ca-client/tls-ca/rcaadmin/msp/signcert` 下生成的，私钥在 `fabric-ca-client/tls-ca/rcaadmin/msp/keystore` 下可用。部署组织 CA 时，您需要在 CA 配置 .yaml 文件的 `tls` 部分中指向这两个文件的位置。为了便于参考，您可以将 `keystore` 文件夹中的文件重命名为 `key.pem` 。

#### （可选）使用 TLS CA 注册并注册中级 CA 管理员

同样，如果您计划拥有一个可以代表组织 CA 发行证书的中间 CA ，那么您现在也应该注册并注册该中间 CA 管理员用户。以下命令向 TLS CA 注册中间 CA 管理员 ID `icaadmin` 和 `icaadminpw` 。您可以使用选择的任何值作为身份名称和密码。

```BASH
./fabric-ca-client register -d --id.name icaadmin --id.secret icaadminpw -u https://my-machine.example.com:7054  --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp
```

同样，register 命令上的 `--mspdir` 标志指向 TLS CA admin msp 证书的位置，这些证书才能够向 TLS CA 注册其他用户。

现在也将是通过注册该用户为 `icaadmin` 用户生成中间 CA TLS 证书的好时机。对于 enroll 命令，我们使用 `--mspdir` 标志指定应为 `icaadmin` 用户存储生成的中间 CA TLS 证书的位置。在这种情况下，我们将它们放在 `tlsadmin` 文件夹旁边的新文件夹 `icaadmin/msp` 中。

```BASH
./fabric-ca-client enroll -d -u https://icaadmin:icaadminpw@my-machine.example.com:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'host1,*.example.com' --mspdir tls-ca/icaadmin/msp
```

重要提示：中间 CA TLS 签名证书是在 `fabric-ca-client/tls-ca/icaadmin/signcert` 下生成的，私钥在 `fabric-ca-client/tls-ca/icaadmin/keystore` 下是可用的。部署中间 CA 时，您需要在中间 CA 配置 .yaml 文件的 `tls` 部分中引用这两个文件。为了便于参考，您可以将 `keystore` 文件夹中的文件重命名为 `key.pem` 。

产生的文件夹结构类似于：

```code
fabric-ca-client
  └── tls-ca
    └── tlsadmin
      └── msp
    └── rcaadmin
      └── msp
    └── icaadmin
      └── msp
    └── tls-root-cert
      └── tls-ca-cert.pem
```

提示：在 TLS CA 中注册了所有节点之后，可以安全地关闭它。

### 部署组织 CA

部署过程概述描述了每个组织对组织 CA 和 TLS CA 的需求。 TLS CA 颁发 TLS 证书，以允许组织内进行安全交易。组织 CA （也称为“注册 CA ”或“ eCert CA ”）用于为组织颁发身份。您已经在上一组步骤中部署了 TLS CA ，现在我们准备部署组织 CA 。在本主题的稍后部分，您可以选择创建中间 CA 。因此，该 CA 成为该信任链中的“根 CA ”。

由于您已在上一步中使用 TLS CA 注册并注册了组织 CA 引导程序身份 `rcaadmin` ，因此您可以按照部署 TLS CA 时所使用的相同步骤模式来部署 CA 。

#### 在开始之前

- 将 Fabric CA 服务器二进制文件 `fabric-ca-server` 复制到计算机上的新目录。出于这些说明的目的，我们将二进制文件放入名为 `fabric-ca-server-org1` 的文件夹中。

```BASH
mkdir fabric-ca-server-org1
```

现在，将 `fabric-ca-server` 二进制文件复制到此文件夹中。

- 使用以下命令，将您在上一步中生成的组织 CA TLS 证书和密钥对复制到此 CA 服务器可以访问的位置，例如 `fabric-ca-server-org1/tls` 。这些是由 enroll 命令生成的 `fabric-ca-client/tls-ca/rcaadmin/msp/signcerts/cert.pem` 和 `fabric-ca-client/tls-ca/rcaadmin/msp/keystore/` 文件。
  注意：以下命令假定：
  - 在 `fabric-ca-client/tls-ca/rcaadmin/msp/keystore/` 下生成的私钥已重命名为 `key.pem` 。
  - `fabric-ca-client` 和 `fabric-ca-server-org1` 文件夹在文件结构中处于同一级别。

```BASH
cd fabric-ca-server-org1
mkdir tls
cp ../fabric-ca-client/tls-ca/rcaadmin/msp/signcerts/cert.pem tls && cp ../fabric-ca-client/tls-ca/rcaadmin/msp/keystore/key.pem tls
```

生成的文件夹结构类似于下图。（为清楚起见，一些文件夹和文件已被省略）：

```code
fabric-ca-client
  └── tls-ca
        ├── rcaadmin
          ├── msp
             ├── IssuerPublicKey
             ├── IssuerRevocationPublicKey
             ├── cacerts
             ├── keystore
                 └── key.pem
             ├── signcerts
                 └── cert.pem
fabric-ca-server-org1
  └── tls
    └── cert.pem
    └── key.pem
```

#### 初始化 CA 服务器

运行命令以初始化服务器，并为 CA 指定新的管理员用户 ID 和密码。我们使用在上一组步骤中向 TLS CA 注册的身份 `rcaadmin` 作为组织 CA 的引导身份。从 `fabric-ca-server-org1` 文件夹运行此命令。

```BASH
./fabric-ca-server init -b <ADMIN_USER>:<ADMIN_PWD>
```

例如：

```BASH
./fabric-ca-server init -b rcaadmin:rcaadminpw
```

#### 修改 CA 服务器配置

与使用 TLS CA 一样，我们需要为组织 CA 编辑生成的 `fabric-ca-server-config.yaml` 文件，以根据生产 CA 服务器的清单修改您的用例的默认配置设置。

至少，您应该编辑以下字段：

- `port` - 输入要用于此服务器的端口。这些说明使用 `7055` ，但您可以选择端口。
- `tls.enabled` - 通过将此值设置为 `true` 来启用 TLS。
- `tls.certfile` 和 `tls.keystore` - 输入在 TLS CA 中注册该 CA 的引导管理员时生成的 TLS CA 签名证书和私钥的相对路径和文件名。签名证书 `cert.pem` 是使用 Fabric CA 客户端生成的，可以在 `fabric-ca-client/tls-ca/rcaadmin/msp/signcerts/cert.pem` 下找到。私钥位于 `fabric-ca-client/tls-ca/rcaadmin/msp/keystore` 下。指定的路径名 ​​ 是相对于 `FABRIC_CA_CLIENT_HOME` 的，因此，如果您遵循这些说明中使用的文件夹结构，则只需为 `tls.certfile` 指定 `tls/cert.pem` ，为 `tls.keystore` 定 `tls/key.pem` 。指定标准路径名。
- `ca.name` - 通过在此参数中指定值来为组织 CA 命名，例如 `org1-ca` 。
- `csr.hosts` - 更新此参数以包含此服务器运行所在的主机名和 IP 地址（如果该文件与文件中已有的名称不同）。
- `Operations.listenAddress:` - 如果此主机上正在运行另一个 CA ，则需要更新此参数以使用其他端口。
- `csr.ca.pathlength` ：此字段用于限制 CA 证书层次结构。根 CA 将此值设置为 1 意味着根 CA 可以颁发中间 CA 证书，但是这些中间 CA 不能依次颁发其他 CA 证书。换句话说，中间 CA 无法注册其他中间 CA ，但可以为用户颁发注册证书。默认值为 1。
- `signing.profiles.ca.caconstraint.maxpathlen` - 此字段表示证书链中可以跟随此证书的非自发行中间证书的最大数量。如果这将是中间 CA 的父服务器，并且您希望该中间 CA 充当另一个中间 CA 的父 CA ，则此根 CA 需要在配置 .yaml 文件中将此值设置为大于 0。请参阅“签名”部分的说明。默认值为 0。
- `Operations.listenAddress:` - 在不太可能的情况下，该主机和端口上正在运行另一个节点，则需要更新此参数以使用其他端口。

#### 删除 CA 服务器证书

启动服务器之前，如果您修改了配置 .yaml 文件的 `csr` 块中的任何值，则需要删除 `fabric-ca-server-org1/ca-cert.pem` 文件和整个 `fabric-ca-server-org1/msp` 文件夹。在下一步中启动 CA 服务器时，将根据配置 .yaml 文件中的新设置重新生成这些证书。

#### 启动 CA 服务器

运行以下命令以启动 CA 服务器：

```BASH
./fabric-ca-server start
```

#### 注册 CA 管理员

部署 CA 的最后一步是注册 CA 管理员引导程序身份，该身份会生成节点签名的证书和私钥。密钥对是此管理员身份所必需的，以便能够注册其他身份。同样，我们将使用 Fabric CA 客户端 CLI 来注册管理员。您应该已经在 Fabric CA 客户端部分中设置了所需的文件夹。

我们用于这些命令的文件夹结构是：

```code
fabric-ca-client
  └── org1-ca
  └── tls-root-cert
```

Fabric CA 客户端将这些文件夹用于：

- 存储对 TLS CA 服务器运行 Fabric CA 客户端注册命令时颁发的证书。（org1-ca 文件夹）
- 知道 TLS 证书位于的位置，该证书允许 Fabric CA 客户端与 TLS CA 服务器进行通信。（tls-root-cert 文件夹）

1. 以前使用 Fabric CA 客户端为 TLS CA 生成证书时，您指定了 `FABRIC_CA_CLIENT_HOME` 的值。假设仍然设置，则可以继续执行下一步。否则，您应该在 Fabric CA 客户端二进制文件所在的目录中，并运行以下命令：

   ```BASH
   export FABRIC_CA_CLIENT_HOME=$PWD
   ```

2. 现在，您可以使用 Fabric CA 客户端生成 CA 管理员证书和私钥。您需要此证书和私钥才能使用此 CA 颁发身份。我们在 enroll 命令上使用 `--mspdir` 标志来指定将生成的证书存储在何处。运行命令：

   ```BASH
   ./fabric-ca-client enroll -d -u https://<ADMIN>:<ADMIN-PWD>@<CA-URL>:<PORT> --tls.certfiles <RELATIVE-PATH-TO-TLS-CERT> --csr.hosts '<CA_HOSTNAME>' --mspdir org1-ca/rcaadmin/msp
   ```

   - `<ADMIN>` - 使用 `init` 命令中指定的组织 CA admin 。
   - `<ADMIN-PWD>` - 使用 `init` 命令中指定的组织 CA 管理员密码。
   - `<CA-URL>` - 使用在组织 CA 配置.yaml 文件的 `csr` 部分中指定的主机名。
   - `<PORT>` - 使用组织 CA 正在侦听的端口。
   - `<RELATIVE-PATH-TO-TLS-CERT>` - 包含从 TLS CA 复制的 tls-ca-cert.pem 文件的路径。这是相对于 `FABRIC_CA_CLIENT_HOME` 的路径。
   - `<CA_HOSTNAME>` - 带有逗号分隔的证书名称的主机名列表。如果未指定，则使用 `fabric-ca-client-config.yaml` 中的默认值。如果主机名是动态的，则可以为域指定通配符。例如，当包含标志 `--csr.hosts 'host1,*.example.com'` 时，意味着主机名 `host1` 以及 `example.com` 域中的任何主机均被识别。

   在这种情况下， `-d` 参数以 DEBUG 模式运行客户机，这对于调试命令失败很有用。

   例如：

   ```BASH
   ./fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@my-machine.example.com:7055 --tls.certfiles tls-root-cert/tls-ca-cert.pem --csr.hosts 'host1,*.example.com' --mspdir org1-ca/rcaadmin/msp
   ```

   运行此命令时，enroll 命令将创建 `fabric-ca-client/org1-ca/rcaadmin/msp` 文件夹，其中包含组织 CA 的签名证书和私钥，其外观类似于：

   ```code
   └── msp
       ├── cacerts
           └── my-machine-example-com-7055.pem
       ├── keystore
           └── 60b6a16b8b5ba3fc3113c522cce86a724d7eb92d6c3961cfd9afbd27bf11c37f_sk
       ├── signcerts
           └── cert.pem
       ├── user
       ├── IssuerPublicKey
       └── IssuerRevocationPublicKey
   ```

   位置：

   - `my-machine-example-com-7055.pem` 是组织 CA 根证书。
   - `60b6a16b8b5ba3fc3113c522cce86a724d7eb92d6c3961cfd9afbd27bf11c37f_sk` 是组- 织 CA 管理员身份的私钥。此密钥需要受到保护，不应与任何人共享。需要能够在此 CA 中注册- 和注册其他身份。可以将这个文件重命名为更易于引用的名称，例如 `org1-key.pem` 。
   - `cert.pem` 是 CA 管理员身份签名的证书。

3. （可选）向组织（根）CA 注册中间 CA 引导程序标识。

如果计划部署中间 CA ，则必须向其根 CA 注册中间 CA 引导程序标识，以形成信任链。回想一下，您已经在 TLS CA 中注册了 `icaadmin` 身份。您还需要在（根）组织 CA 中注册相同的身份。并且由于这将是中间 CA ，因此必须包含 `hf.IntermediateCA = true` 属性。（从在上一步中注册组织 CA admin 的同一终端窗口中运行此命令。）

```BASH
./fabric-ca-client register -u https://my-machine.example.com:7055  --id.name icaadmin --id.secret icaadminpw --id.attrs '"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir org1-ca/rcaadmin/msp
```

register 命令上的 `--mspdir` 标志指向我们在上一步中注册的组织 CA admin 的加密材料，并被授权注册新用户。我们不会在组织 CA 中注册 `icaadmin` 身份。相反，此中间 CA 管理员身份稍后将针对中间 CA 进行注册。

### （可选）部署中间 CA

中间 CA 与组织根 CA 形成信任链，可用于将特定组织的注册请求定向到单个 CA ，以及通过关闭根 CA 来保护信任根。因此，当使用中间 CA 来处理所有注册请求时，可以关闭根 CA 。

注意：本节假定您已经在 TLS CA 和上级组织 CA 中注册并注册了 `icaadmin` 身份（本节之前的第 3 步）。

在你开始之前

- 将 Fabric CA 服务器二进制 `fabric-ca-server` 复制到计算机上的新目录。出于这些说明的目的，我们将二进制文件放入其自己的名为 `fabric-ca-server-int-ca`的文件夹中。

```BASH
mkdir fabric-ca-server-int-ca
```

将 `fabric-ca-server` 二进制文件复制到此文件夹中。

- 使用以下命令将在上一步中生成的 CA admin TLS 证书和密钥对复制到此 CA 服务器可以访问的位置，例如 `fabric-ca-server-int-ca/tls` 。这些是由 enroll 命令生成的 `fabric-ca-client/tls-ca/icaadmin/msp/signcerts/cert.pem` 和 `fabric-ca-client/tls-ca/icaadmin/msp/keystore/` 文件。
  注意：以下命令假定：

  - 在 `fabric-ca-client/tls-ca/icaadmin/keystore/` 下生成的私钥被重命名为 `key.pem` 。
  - `fabric-ca-client` 和 `fabric-ca-server-int-ca` 文件夹在文件结构中处于同一级别。

```BASH
cd fabric-ca-server-int-ca
mkdir tls
cp ../fabric-ca-client/tls-ca/icaadmin/msp/signcerts/cert.pem tls && cp ../fabric-ca-client/tls-ca/icaadmin/msp/keystore/key.pem tls
```

- 因为启用了 TLS 通信，所以中间 CA 需要 TLS CA 根证书才能与上级组织 CA 安全通信。因此，您需要将初始化 TLS CA 服务器时生成的 `fabric-ca-server-tls/ca-cert.pem` 复到 `tls` 文件夹。请注意，文件名已更改为 `tls-ca-cert.pem` ，以使其清楚这是来自 TLS CA 的根证书。

```BASH
cp ../fabric-ca-server-tls/ca-cert.pem tls/tls-ca-cert.pem
```

生成的文件夹结构类似于以下结构。（为清楚起见，一些文件夹和文件已被省略）：

```code
fabric-ca-client
  └── tls-ca
        ├── icaadmin
          ├── msp
             ├── cacerts
             ├── keystore
                 └── key.pem
             ├── signcerts
                 └── cert.pem
             ├── tlscacerts
             ├── user
             ├── IssuerPublicKey
             └── IssuerRevocationPublicKey
fabric-ca-server-int-ca
  └── tls
    └── tls-ca-cert.pem
    └── cert.pem
    └── key.pem
```

因为您已经部署了父组织（根） CA ，所以可以使用以下步骤来创建中间 CA：

1. 在中间 CA 主目录中，通过运行 `init` 命令并引导您已经在 TLS CA 和父组织 CA 中注册的 `icaadmin` id 来初始化 CA 。
   例如：

   ```BASH
   ./fabric-ca-server init -b icaadmin:icaadminpw
   ```

2. 修改 `fabric-ca-server-config.yaml` 文件。

未完。。。
