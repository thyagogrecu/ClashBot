# Inventário do MyBot PH MOD (Fael / "Phael")

Análise do código em `MyBot/` (enviado em 0cc9514): **MyBot PH MOD v16.0**.

## Como foi feita a análise

- Comparação com o MyBot.run oficial **v8.2.0**, a última versão com código-fonte publicado
  em `github.com/MyBotRun/MyBot` (maio/2025).
- Resultado: **231 arquivos `.au3` alterados** (~43 mil linhas diferentes, ignorando espaços),
  **19 arquivos `.au3` novos**, 4 scripts CSV novos e ~50 OCRs/imagens novos em `lib/` e `ImgXML/`.
- **582 textos novos na interface** (opções, abas, dicas), usados para mapear as funcionalidades.
- Ressalva: parte das diferenças pode ter vindo de releases oficiais do MBR posteriores à v8.2.0
  (sem código público) ou de outros mods. Só os 21 arquivos assinados "Phael" são
  autoria confirmada do Fael.

## Arquivos de autoria do Fael (assinados "Phael")

| Arquivo | Função |
|---|---|
| `MultiBot.au3` (1.862 linhas) | Gerenciador de perfis, instâncias de emulador, parâmetros de inicialização e controle de processos em grupo |
| `COCBot/functions/Attack/AttackCycle.au3` | Ciclos de ataque (inicial e rotina) intercalados com tarefas da vila |
| `COCBot/functions/Attack/ScriptRotation.au3` + GUI | Rotação de scripts CSV e "Saved Recipes" em 3 fases |
| `COCBot/functions/Attack/DirectAttack.au3` | Botão "Direct Attack": ataca direto da tela de batalha |
| `COCBot/functions/Attack/TagTeam.au3` | Evento Tag Team: detecta recompensa (carta dourada) e aplica estratégia |
| `COCBot/functions/Attack/AtkReport.au3` | Teste de OCR do relatório de ataque a partir de PNG |
| `COCBot/functions/Attack/BuilderBase/BBSpam.au3` | Ataques em série na Base do Construtor monitorando limites de recursos |
| `COCBot/functions/Search/RankedBattle.au3` | Detecta e entra em Batalhas Ranqueadas |
| `COCBot/functions/Search/RevengeBattle.au3` | Vingança automática a partir do log de defesa |
| `COCBot/functions/CreateArmy/getArmyHeroes/HeroStatus.au3` | Status dos heróis no Hero Hall (disponível/upgrade) |
| `COCBot/functions/Village/AutoPetUpgrade.au3` | Upgrade automático de Pets pelo menu do construtor |
| `COCBot/functions/Village/CCSpam.au3` | Repete doações do CC com cooldown ("CC Spam") |
| `COCBot/functions/Village/BuilderBase/AutoUpgradeBB.au3` | Auto upgrade da BB + Star Laboratory |
| `COCBot/functions/Image Search/ImgCapture.au3` | Ferramenta de captura de imagens/marcadores para `imgxml` |
| Modificados: `Auto Upgrade.au3`, `RequestCC.au3`, `CleanBBYard.au3`, `getArmyCCStatus.au3`, `CheckAndroidRebootCondition.au3` | |

Outros novos (de terceiros): `ClashOfCards.au3` (CalebWeisgerber, evento de cartas de agosto),
`SmartZap.au3` reorganizado, `ClockTowerBoost.au3` (Moebius14).

## Funcionalidades por área

### Escala / multicontas (o mais relevante para 30+ contas)
- **Switch Accounts: 8 grupos × 16 contas** (`$g_iSwitchAccMaxGroups = 8`, `$g_iSwitchAccMaxAccounts = 16`
  em `COCBot/MBR Global Variables.au3:1390`), com paginação de 8 por tela.
- Suporte a contas **Supercell ID (SCID)**, log próprio de troca ("SwitchAcc Log").
- "Switch While Waiting": troca de conta se as tropas do CC não chegam em 1 minuto.
- Trava para impedir o mesmo grupo/perfil em duas instâncias; fila "Waiting for launch slot".
- **MultiBot**: abre/fecha várias instâncias (perfil + emulador + instância + parâmetros) em grupo.
- Opções de economia: Skip Initial Check, Skip Training System, Skip Search Filter, Auto Hide Android,
  Auto START / Auto Resume, espera configurável quando "Another Device" conecta.

### Ataque
- Attack Cycles (nº de ataques no ciclo inicial), Consecutive Attack Limits, atrasos aleatórios.
- Script Rotation (Recipe 1/2/3), Direct Attack, Ranked Battle, Revenge Battle, Tag Team.
- Deploy Timing (1 a 9) no padrão e Smart Farm; "Smart Attack: Near Red Line"; Sky Wagon; Castle Only.
- **SmartZap refeito**: alvo primário/secundário (Drills, Air Defense, Infernos, XBow, Eagle,
  Scattershot, Monolith, Firespitter etc.), Lightning e Earthquake por alvo, timing início/meio/fim.
- End Battle avançado: por estrelas, % de dano, loot abaixo do limite, loot/dano inalterado por X s.
- Replay & Loot Snapshot, compartilhar replay, Battle Speed automático, Troop Skills.
- "Wait for Clan Castle" antes de atacar, CC Spam Control, tropas de evento e Super Tropas.
- Scripts CSV novos: `PHMOD-DragLoon`, `PHMOD-MeteorMayhem`, `PHMOD-Thrower Smash`, `PHMOD-TroopSpam`;
  ajuda com as abreviações aceitas nos CSV.

### Vila / upgrades
- Auto Upgrade com tipo (Army/Defense/Hero/Resource), recurso e ordenação (custo, tempo).
- Auto Laboratory com 3 prioridades; Lab Assistant (mais longo/mais curto); Star Laboratory.
- Heróis incluindo Príncipe/Dragon Duke (com avisos de upgrade ativo), Greedy Raven, Pets, Hero Equipment
  (Electro Fangs, Fire Heart, Rocket Backpack, Stick Horse, Meteor Staff etc.), Guardians, Helper Hut.
- Muros: reserva de ouro/elixir, % de armazém, Hammer Jam, contador de muros, reservar construtor.
- Reserva de construtores para upgrades configurados.

### Base do Construtor
- BB Spam, ataque em 1/2/todos os lados, prioridade de defesas, só atacar com estrelas disponíveis,
  Drop Trophies, BOB Upgrade, Auto Upgrade BB + Star Lab, Clock Tower Boost.

### Clã / eventos
- Doações: "Donate To All", tropas aleatórias para pedidos sem especificação, CC Spam.
- Clan Games: evitar desafios de 1 dia, purgar não selecionados, reservar pontos (parar a 300 do limite),
  desativar ao completar, notificações.
- Capital: doar todo o Capital Gold ao Tesouro; Gold Pass Forge; Clash of Cards.

### Notificações (Telegram) e controle remoto
- Alertas: troca de conta/base, Clan Games, último raid (vila e BB) como imagem, "Another Device", pausa.
- Comandos: BBSPAM, CCSPAM, RUSHATK, halt/stay online, screenshot de construtores e escudo,
  log, loot do último raid, estatísticas da vila e tropas, reiniciar emulador+bot.

### Android / emulador
- Minitouch para clique e arrasto precisos, ADB dedicado por porta, opções de screencap.
- Correção Hyper-V para MEmu (`AndroidMEmu.au3:219`), ajustes BlueStacks 5, ZoomOut MEmu (minitouch).

### Debug / desenvolvimento
- ImgCapture (gerar marcadores de imagem), testes de OCR (Battle OCR, AtkReport), GetLocation de
  construções, testes de Ranked/Revenge/PrepareAttack, estatísticas em SQLite.

## Como compilar

No Windows, dentro de `MyBot/`: `AutoIt Full Compile.bat` (o AutoIt já vem na pasta `AutoIt/`).
