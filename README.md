# Linux Infrastructure as Code - Project 1
### Infraestrutura como Código - Projeto 1

[![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)](https://www.linux.org/)

---

## 📖 Table of Contents / Índice

- [English Documentation](#english-documentation)
  - [Project Overview](#project-overview)
  - [Prerequisites](#prerequisites)
  - [Script Features](#script-features)
  - [Step-by-Step Explanation](#step-by-step-explanation)
  - [How to Execute](#how-to-execute)
  - [Security Considerations](#security-considerations)
- [Documentação em Português](#documentação-em-português)
  - [Visão Geral do Projeto](#visão-geral-do-projeto)
  - [Pré-requisitos](#pré-requisitos)
  - [Funcionalidades do Script](#funcionalidades-do-script)
  - [Explicação Passo a Passo](#explicação-passo-a-passo)
  - [Como Executar](#como-executar)
  - [Considerações de Segurança](#considerações-de-segurança)

---

## English Documentation

### Project Overview

This project provides an **Infrastructure as Code (IaC)** solution for automating user and group management on Linux systems. The bash script (`iac1.sh`) automates the creation of organizational directories, user groups, and user accounts with appropriate permissions, making it ideal for:

- Setting up multi-user Linux environments
- Implementing role-based access control (RBAC)
- Standardizing user provisioning processes
- Educational purposes for learning Linux administration
- Quick deployment of development or testing environments

The script follows Linux best practices for user management and implements a departmental structure with three main groups: Administration (ADM), Sales (VEN), and Security (SEC).

### Prerequisites

Before running this script, ensure you have:

1. **Operating System**: Linux distribution (Ubuntu, Debian, CentOS, RHEL, etc.)
2. **User Privileges**: Root or sudo access
3. **Shell**: Bash shell (usually default on Linux systems)
4. **Tools**: Standard Linux utilities (`useradd`, `groupadd`, `chmod`, `chown`)

**System Requirements:**
- Minimum: Any modern Linux distribution
- Recommended: Fresh installation or testing environment
- Disk Space: Minimal (< 10MB for user home directories)

### Script Features

The `iac1.sh` script provides the following automated features:

#### 1. **Directory Creation**
- Creates four organizational directories:
  - `/publico` - Public shared space (accessible to all)
  - `/adm` - Administration department directory
  - `/ven` - Sales (Vendas) department directory
  - `/sec` - Security department directory

#### 2. **Group Management**
- Creates three department-specific groups:
  - `GRP_ADM` - Administration group
  - `GRP_VEN` - Sales group
  - `GRP_SEC` - Security group

#### 3. **User Creation**
- Creates 10 user accounts distributed across departments:
  - **Administration (GRP_ADM)**: carlos, maria, joao
  - **Sales (GRP_VEN)**: debora, sebastiana, roberto
  - **Security (GRP_SEC)**: josefina, amanda, rogerio

#### 4. **Automatic Permission Configuration**
- Sets appropriate ownership and permissions for department directories
- Implements secure access control (770 permissions)
- Forces password change on first login

### Step-by-Step Explanation

#### 1. User Creation

The script creates users with the following command structure:

```bash
sudo useradd <username> -m -s /bin/bash -G <GROUP>
```

**Parameter breakdown:**
- `<username>`: The account name for the new user
- `-m`: Creates a home directory at `/home/<username>`
- `-s /bin/bash`: Sets bash as the default shell
- `-G <GROUP>`: Adds the user to a specific supplementary group

**Example:**
```bash
sudo useradd carlos -m -s /bin/bash -G GRP_ADM
```

This creates user "carlos" with a home directory, bash shell, and membership in the GRP_ADM group.

#### 2. Group Creation

Groups are created before users to ensure proper assignment:

```bash
groupadd GRP_ADM
groupadd GRP_VEN
groupadd GRP_SEC
```

These commands create system groups that will be used for organizing users by department and controlling access to shared resources.

#### 3. Permission Settings

The script implements a two-step permission model:

**Step 1: Ownership Assignment**
```bash
chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec
```

- Sets `root` as the owner of each directory
- Assigns the appropriate group to each directory
- Ensures centralized control while allowing group access

**Step 2: Permission Configuration**
```bash
chmod 770 /adm
chmod 770 /ven
chmod 770 /sec
```

**Permission breakdown (770):**
- **7 (Owner/root)**: Read, Write, Execute (full control)
- **7 (Group)**: Read, Write, Execute (full access for group members)
- **0 (Others)**: No permissions (complete isolation)

This ensures that:
- Only group members can access their department directory
- Group members have full permissions within their directory
- Users outside the group cannot view, modify, or enter the directory

#### 4. Password Security

After each user creation:
```bash
sudo passwd -e <username>
```

The `-e` flag expires the password immediately, forcing users to set their own password on first login. This ensures:
- No default or shared passwords exist
- Each user creates a secure, personal password
- Compliance with security best practices

### How to Execute

#### Method 1: Basic Execution

1. **Download or clone the repository:**
```bash
git clone https://github.com/VandyckLN/linux-projeto1-iac.git
cd linux-projeto1-iac
```

2. **Make the script executable:**
```bash
chmod +x iac1.sh
```

3. **Run the script with sudo:**
```bash
sudo ./iac1.sh
```

#### Method 2: Direct Execution

```bash
sudo bash iac1.sh
```

#### Expected Output

```
criando diretórios...
 Diretórios criados !
 Criando grupo de usuários
 Grupos Criados!
 Criando usuários...
[Password expiration messages for each user]
 Adcionando Usuarios aos grupos ...
Finalizando Script de criação de Usuarios , grupos e permissões
```

#### Verification

After execution, verify the setup:

```bash
# Check created groups
cat /etc/group | grep GRP_

# Check created users
cat /etc/passwd | grep -E "carlos|maria|joao|debora|sebastiana|roberto|josefina|amanda|rogerio"

# Check directory permissions
ls -la / | grep -E "publico|adm|ven|sec"

# Check user group membership
groups carlos
groups debora
groups josefina
```

### Security Considerations

⚠️ **Important Security Notes:**

#### 1. **Run Only in Controlled Environments**
- This script makes system-level changes
- Test in a virtual machine or isolated environment first
- **Never run untested scripts on production systems**

#### 2. **Root/Sudo Privileges Required**
- The script requires elevated privileges
- Review the script content before execution
- Understand that it will modify system user databases

#### 3. **Password Management**
- Users are created with expired passwords
- Users **must** set their own password on first login
- Ensure password policy compliance (complexity, length)
- Consider implementing PAM (Pluggable Authentication Modules) for password policies

#### 4. **Duplicate User Warning**
- The script contains a duplicate entry for "carlos" (lines 25 and 41)
- This will cause an error on the second creation attempt
- Consider removing the duplicate before running in production

#### 5. **Idempotency Warning**
- Running the script multiple times will cause errors
- Users and groups already existing will fail to be created
- Consider adding existence checks before creation:
```bash
if ! getent group GRP_ADM > /dev/null 2>&1; then
    groupadd GRP_ADM
fi
```

#### 6. **Audit and Compliance**
- Keep logs of when the script is executed
- Document which systems have been configured
- Maintain a list of created users for auditing purposes
- Consider using `logger` command to send events to syslog

#### 7. **Directory Isolation**
- The 770 permission model provides strong isolation
- `/publico` directory has default permissions - consider securing it if needed
- Regularly audit directory permissions: `ls -la /`

#### 8. **User Account Management**
- Implement account expiration policies for temporary users
- Regularly review and deactivate unused accounts
- Monitor login activities: `last` and `lastlog` commands

#### 9. **Backup Considerations**
- Backup `/etc/passwd`, `/etc/shadow`, `/etc/group` before running
- Keep a rollback plan in case of errors
- Document the initial system state

#### 10. **Best Practices for Production Use**
- Add error handling (`set -e`, `set -u`)
- Implement logging for all operations
- Add user input validation
- Create a cleanup/removal script for testing purposes
- Use configuration files instead of hardcoded values

---

## Documentação em Português

### Visão Geral do Projeto

Este projeto fornece uma solução de **Infraestrutura como Código (IaC)** para automatizar o gerenciamento de usuários e grupos em sistemas Linux. O script bash (`iac1.sh`) automatiza a criação de diretórios organizacionais, grupos de usuários e contas de usuário com permissões apropriadas, sendo ideal para:

- Configuração de ambientes Linux multiusuário
- Implementação de controle de acesso baseado em funções (RBAC)
- Padronização de processos de provisionamento de usuários
- Propósitos educacionais para aprendizado de administração Linux
- Implantação rápida de ambientes de desenvolvimento ou teste

O script segue as melhores práticas do Linux para gerenciamento de usuários e implementa uma estrutura departamental com três grupos principais: Administração (ADM), Vendas (VEN) e Segurança (SEC).

### Pré-requisitos

Antes de executar este script, certifique-se de ter:

1. **Sistema Operacional**: Distribuição Linux (Ubuntu, Debian, CentOS, RHEL, etc.)
2. **Privilégios de Usuário**: Acesso root ou sudo
3. **Shell**: Bash shell (geralmente padrão em sistemas Linux)
4. **Ferramentas**: Utilitários Linux padrão (`useradd`, `groupadd`, `chmod`, `chown`)

**Requisitos do Sistema:**
- Mínimo: Qualquer distribuição Linux moderna
- Recomendado: Instalação nova ou ambiente de teste
- Espaço em Disco: Mínimo (< 10MB para diretórios home dos usuários)

### Funcionalidades do Script

O script `iac1.sh` fornece as seguintes funcionalidades automatizadas:

#### 1. **Criação de Diretórios**
- Cria quatro diretórios organizacionais:
  - `/publico` - Espaço público compartilhado (acessível a todos)
  - `/adm` - Diretório do departamento de Administração
  - `/ven` - Diretório do departamento de Vendas
  - `/sec` - Diretório do departamento de Segurança

#### 2. **Gerenciamento de Grupos**
- Cria três grupos específicos por departamento:
  - `GRP_ADM` - Grupo de Administração
  - `GRP_VEN` - Grupo de Vendas
  - `GRP_SEC` - Grupo de Segurança

#### 3. **Criação de Usuários**
- Cria 10 contas de usuário distribuídas entre departamentos:
  - **Administração (GRP_ADM)**: carlos, maria, joao
  - **Vendas (GRP_VEN)**: debora, sebastiana, roberto
  - **Segurança (GRP_SEC)**: josefina, amanda, rogerio

#### 4. **Configuração Automática de Permissões**
- Define propriedade e permissões apropriadas para diretórios departamentais
- Implementa controle de acesso seguro (permissões 770)
- Força mudança de senha no primeiro login

### Explicação Passo a Passo

#### 1. Criação de Usuários

O script cria usuários com a seguinte estrutura de comando:

```bash
sudo useradd <nome_usuario> -m -s /bin/bash -G <GRUPO>
```

**Detalhamento dos parâmetros:**
- `<nome_usuario>`: O nome da conta para o novo usuário
- `-m`: Cria um diretório home em `/home/<nome_usuario>`
- `-s /bin/bash`: Define o bash como shell padrão
- `-G <GRUPO>`: Adiciona o usuário a um grupo suplementar específico

**Exemplo:**
```bash
sudo useradd carlos -m -s /bin/bash -G GRP_ADM
```

Isso cria o usuário "carlos" com um diretório home, shell bash e associação ao grupo GRP_ADM.

#### 2. Criação de Grupos

Os grupos são criados antes dos usuários para garantir a atribuição adequada:

```bash
groupadd GRP_ADM
groupadd GRP_VEN
groupadd GRP_SEC
```

Esses comandos criam grupos de sistema que serão usados para organizar usuários por departamento e controlar o acesso a recursos compartilhados.

#### 3. Configuração de Permissões

O script implementa um modelo de permissões em duas etapas:

**Etapa 1: Atribuição de Propriedade**
```bash
chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec
```

- Define `root` como proprietário de cada diretório
- Atribui o grupo apropriado a cada diretório
- Garante controle centralizado enquanto permite acesso do grupo

**Etapa 2: Configuração de Permissões**
```bash
chmod 770 /adm
chmod 770 /ven
chmod 770 /sec
```

**Detalhamento das permissões (770):**
- **7 (Proprietário/root)**: Leitura, Escrita, Execução (controle total)
- **7 (Grupo)**: Leitura, Escrita, Execução (acesso total para membros do grupo)
- **0 (Outros)**: Sem permissões (isolamento completo)

Isso garante que:
- Apenas membros do grupo podem acessar seu diretório departamental
- Membros do grupo têm permissões completas dentro de seu diretório
- Usuários fora do grupo não podem visualizar, modificar ou entrar no diretório

#### 4. Segurança de Senha

Após a criação de cada usuário:
```bash
sudo passwd -e <nome_usuario>
```

A flag `-e` expira a senha imediatamente, forçando os usuários a definir sua própria senha no primeiro login. Isso garante:
- Nenhuma senha padrão ou compartilhada existe
- Cada usuário cria uma senha segura e pessoal
- Conformidade com melhores práticas de segurança

### Como Executar

#### Método 1: Execução Básica

1. **Baixe ou clone o repositório:**
```bash
git clone https://github.com/VandyckLN/linux-projeto1-iac.git
cd linux-projeto1-iac
```

2. **Torne o script executável:**
```bash
chmod +x iac1.sh
```

3. **Execute o script com sudo:**
```bash
sudo ./iac1.sh
```

#### Método 2: Execução Direta

```bash
sudo bash iac1.sh
```

#### Saída Esperada

```
criando diretórios...
 Diretórios criados !
 Criando grupo de usuários
 Grupos Criados!
 Criando usuários...
[Mensagens de expiração de senha para cada usuário]
 Adcionando Usuarios aos grupos ...
Finalizando Script de criação de Usuarios , grupos e permissões
```

#### Verificação

Após a execução, verifique a configuração:

```bash
# Verificar grupos criados
cat /etc/group | grep GRP_

# Verificar usuários criados
cat /etc/passwd | grep -E "carlos|maria|joao|debora|sebastiana|roberto|josefina|amanda|rogerio"

# Verificar permissões de diretórios
ls -la / | grep -E "publico|adm|ven|sec"

# Verificar associação de usuários a grupos
groups carlos
groups debora
groups josefina
```

### Considerações de Segurança

⚠️ **Notas Importantes de Segurança:**

#### 1. **Execute Apenas em Ambientes Controlados**
- Este script faz alterações no nível do sistema
- Teste em uma máquina virtual ou ambiente isolado primeiro
- **Nunca execute scripts não testados em sistemas de produção**

#### 2. **Privilégios Root/Sudo Necessários**
- O script requer privilégios elevados
- Revise o conteúdo do script antes da execução
- Entenda que ele modificará os bancos de dados de usuários do sistema

#### 3. **Gerenciamento de Senhas**
- Usuários são criados com senhas expiradas
- Usuários **devem** definir sua própria senha no primeiro login
- Garanta conformidade com política de senhas (complexidade, comprimento)
- Considere implementar PAM (Pluggable Authentication Modules) para políticas de senha

#### 4. **Aviso de Usuário Duplicado**
- O script contém uma entrada duplicada para "carlos" (linhas 25 e 41)
- Isso causará um erro na segunda tentativa de criação
- Considere remover a duplicata antes de executar em produção

#### 5. **Aviso de Idempotência**
- Executar o script várias vezes causará erros
- Usuários e grupos já existentes falharão ao serem criados
- Considere adicionar verificações de existência antes da criação:
```bash
if ! getent group GRP_ADM > /dev/null 2>&1; then
    groupadd GRP_ADM
fi
```

#### 6. **Auditoria e Conformidade**
- Mantenha logs de quando o script é executado
- Documente quais sistemas foram configurados
- Mantenha uma lista de usuários criados para fins de auditoria
- Considere usar o comando `logger` para enviar eventos ao syslog

#### 7. **Isolamento de Diretórios**
- O modelo de permissões 770 fornece forte isolamento
- O diretório `/publico` tem permissões padrão - considere protegê-lo se necessário
- Audite regularmente as permissões dos diretórios: `ls -la /`

#### 8. **Gerenciamento de Contas de Usuário**
- Implemente políticas de expiração de conta para usuários temporários
- Revise e desative regularmente contas não utilizadas
- Monitore atividades de login: comandos `last` e `lastlog`

#### 9. **Considerações de Backup**
- Faça backup de `/etc/passwd`, `/etc/shadow`, `/etc/group` antes de executar
- Mantenha um plano de rollback em caso de erros
- Documente o estado inicial do sistema

#### 10. **Melhores Práticas para Uso em Produção**
- Adicione tratamento de erros (`set -e`, `set -u`)
- Implemente logging para todas as operações
- Adicione validação de entrada do usuário
- Crie um script de limpeza/remoção para fins de teste
- Use arquivos de configuração em vez de valores hardcoded

---

## 📝 License / Licença

This project is open source and available for educational and commercial use.

Este projeto é open source e disponível para uso educacional e comercial.

## 🤝 Contributing / Contribuindo

Contributions are welcome! Feel free to open issues or submit pull requests.

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## 📧 Contact / Contato

For questions or suggestions, please open an issue in this repository.

Para dúvidas ou sugestões, por favor abra uma issue neste repositório.

---

**Note**: Always review and test scripts in a safe environment before running them on production systems.

**Nota**: Sempre revise e teste scripts em um ambiente seguro antes de executá-los em sistemas de produção.
