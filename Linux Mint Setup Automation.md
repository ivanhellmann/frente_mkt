# Linux Mint Setup Automation

Este repositório contém um script para automatizar a configuração pós-instalação do Linux Mint, incluindo a instalação de softwares essenciais como Wine, RustDesk, um sistema de PDV e a personalização do papel de parede.

## Estrutura do Repositório

- `setup.sh`: O script principal de automação.
- `installers/`: Pasta para armazenar os instaladores de softwares (ex: `.deb` do RustDesk, `.exe` do PDV).
- `assets/`: Pasta para armazenar arquivos de mídia, como o papel de parede (`wallpaper.jpg`).

## Pré-requisitos

- Uma instalação limpa do Linux Mint.
- Conexão com a internet.
- Permissões de `sudo`.

## Como Usar

1.  **Clone o Repositório:**

    ```bash
    git clone https://github.com/SEU_USUARIO/linux-mint-setup-automation.git
    cd linux-mint-setup-automation
    ```

2.  **Prepare os Instaladores e Assets:**

    -   **RustDesk:** Baixe a versão mais recente do RustDesk para Linux (arquivo `.deb` para sistemas baseados em Debian/Ubuntu) do site oficial ou do GitHub e coloque-o na pasta `installers/`. Renomeie-o para `rustdesk.deb` para simplificar o script.
        Exemplo: `mv ~/Downloads/rustdesk-*.deb installers/rustdesk.deb`
    -   **Sistema de PDV:** Coloque o instalador do seu sistema de PDV (geralmente um arquivo `.exe`) na pasta `installers/`. Certifique-se de que o nome do arquivo esteja atualizado no script `setup.sh` se for diferente de `nome_do_pdv.exe`.
    -   **Papel de Parede:** Coloque a imagem que deseja usar como papel de parede na pasta `assets/` e renomeie-a para `wallpaper.jpg`.

3.  **Execute o Script:**

    Torne o script executável e execute-o:

    ```bash
    chmod +x setup.sh
    ./setup.sh
    ```

    O script apresentará um menu com opções para instalar cada componente individualmente ou todos de uma vez.

## Funções do Script

-   **Instalar Wine:** Instala o Wine através do `wine-installer` do repositório oficial do Mint.
-   **Instalar RustDesk:** Instala o RustDesk a partir do arquivo `.deb` colocado na pasta `installers/`.
-   **Instalar PDV (via Wine):** Prepara o ambiente para a instalação do PDV. Você precisará executar o instalador `.exe` manualmente após o Wine estar configurado.
-   **Trocar Papel de Parede:** Detecta o ambiente de desktop (Cinnamon, MATE, XFCE) e define o `wallpaper.jpg` da pasta `assets/` como papel de parede.

## Personalização

Você pode editar o arquivo `setup.sh` para:

-   Adicionar mais softwares à instalação.
-   Atualizar os links de download para versões mais recentes.
-   Modificar os caminhos dos arquivos.

## Contribuição

Sinta-se à vontade para fazer um fork deste repositório, propor melhorias e enviar pull requests.
