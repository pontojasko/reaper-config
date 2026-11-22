# REAPER config do Jasko

Backup privado das configurações do REAPER, com instaladores para Linux e Windows.

## Instalar no Linux

Clone este repositório e rode:

```bash
./install-linux.sh
```

O script faz backup do perfil existente, instala as preferências e recursos portáveis, configura o tema Reapertips, ativa a paleta SWELL escura para a barra de menus do REAPER e leva os presets VST3 para `Documents/VST3 Presets`.

## Instalar no Windows

Clone este repositório e rode no PowerShell:

```powershell
.\install-windows.ps1
```

O script faz backup do perfil existente em `%APPDATA%\REAPER` antes de aplicar as configurações. A barra de menus nativa do Windows continua seguindo o Windows; a paleta SWELL escura é exclusiva do REAPER para Linux.

Com GitHub CLI instalado, clone o repositório privado com:

```text
gh repo clone pontojasko/reaper-config
```

## O que está incluído

- Preferências, atalhos, menus, telas, configurações do SWS/ReaPack/ReaImGui e estado de extensões.
- Temas, scripts, efeitos JSFX, templates, presets REAPER, dados auxiliares e cursores do Windows.
- Presets VST3 guardados em `Documents/VST3 Presets`.
- Configuração de REAPER separada para Linux e Windows. Caminhos pessoais conhecidos são convertidos durante a instalação.

## O que fica fora

- Chaves de API: a chave salva no estado do AutoMixAI foi removida. Configure-a de novo no computador de destino.
- Registro/licença do REAPER, cache de scan de plugins, caches do ReaPack, configurações de dispositivos MIDI/áudio e plugins binários.
- Logs temporários do AutoMixAI, projetos REAPER e arquivos de áudio.

Os plugins VST/VST3 precisam ser instalados separadamente para cada sistema operacional. As extensões SWS, ReaPack, ReaImGui e js_ReaScriptAPI também precisam das versões nativas do sistema de destino.

## Atualizar este backup

Depois de alterar configurações no REAPER, copie os arquivos e pastas desejados para `profile/` e ajuste os arquivos em `platform/` se uma preferência depender do sistema operacional. Não copie `reaper-reginfo2.ini`, chaves de API, caches temporários ou binários de plugins para o repositório.

## Tema escuro do REAPER no Linux

`platform/linux/libSwell-user.colortheme` usa a paleta ReaLinux Dark, distribuída em [ReaLinuxThemes.zip](https://stash.reaper.fm/43867/ReaLinuxThemes.zip). Ela escurece a barra superior, menus, controles e diálogos que o tema `.ReaperThemeZip` não controla.
