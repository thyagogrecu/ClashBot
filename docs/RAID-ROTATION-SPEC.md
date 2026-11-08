# Especificação — Raid Rotation (Capital do Clã)

Status: rascunho, decisões tomadas na conversa com o usuário.

## Objetivo

Automatizar o Raid Weekend da Capital do Clã em várias contas, em sequência, para um clã alvo.

## Papéis por conta (configurado no perfil)

| Papel | Fluxo |
|---|---|
| **Desligado** | Não participa. |
| **Fixo** | Já é membro do clã alvo. Ataca todos os ataques disponíveis → doa todo o Capital Gold → marca "feito" → próxima conta. Nunca entra/sai de clã. |
| **Visitante** | Entra no clã alvo pela tag → ataca todos os ataques → doa todo o Capital Gold → sai do clã → marca "feito" → próxima conta. |

Exemplo do usuário: ~15 contas Fixas + ~50 contas Visitantes (CV6).

## Configuração global

- Tag do clã alvo.
- Ordem: Fixos primeiro (garantem as vagas deles).
- Limite de visitantes por fim de semana (padrão = 50 − nº de fixos; confirmar o limite de
  participantes do Raid Weekend no jogo).
- Registro por fim de semana (`raid_<data-de-início>.ini`) para não repetir contas após reinício.

## Ataque no raid

1. Abrir o mapa do raid e escolher um distrito ainda não destruído.
2. Selecionar cada tropa/feitiço e soltar (ver "Pontos de drop").
3. Confirmar que a barra de tropas está vazia.
4. **Fechar e reabrir o jogo** (`CloseCoC(True)`) em vez de esperar o fim da batalha.
   - Validar com 1 conta que o dano conta igual a um ataque assistido até o fim.
5. Repetir até acabarem os ataques da conta.

### Composição padrão e feitiços

- Padrão (configurável): **Super Miners + 2 Frost** (spam mais usado pela comunidade).
- Os feitiços precisam ser lançados **antes** de fechar o jogo.
- **Regra do usuário: os 2 Frost NUNCA no mesmo lugar.**
  - Frost 1: alguns segundos após soltar os mineradores, à frente do ponto de drop
    (direção do centro do mapa / primeiras defesas).
  - Frost 2: alguns segundos depois, em outro ponto, mais adentro na mesma direção.
  - Distância mínima entre os dois centros ≥ 2× o raio do Frost (sem sobreposição);
    se o ponto calculado violar isso, deslocar até respeitar.
  - Verificar pela barra que cada Frost saiu (contador do feitiço caiu) antes de fechar.
- Spam preparado para Skeleton Park ser o distrito mais fraco para mineradores (aceitar menos dano ali).

Futuro: opção geral "Fechar o jogo após soltar tudo" também para vila e Base do Construtor.

## Pontos de drop (sem configuração por mapa)

Ideia do usuário: se a tropa não sair, procurar no mapa até achar onde soltar.

Algoritmo:
1. **Primeira tentativa:** pontos nas bordas da tela (onde normalmente fica a zona liberada).
2. **Verificação a cada toque:** ler a quantidade da tropa na barra (`getTroopCountBig`/`getTroopCountSmall`).
   Caiu → ponto válido. Não caiu → ponto inválido.
3. **Busca:** se inválido, tocar em pontos aleatórios por todo o mapa, das bordas para o centro,
   sem repetir lugares já testados, até a tropa sair.
4. **Reaproveitar:** achado um ponto válido, soltar o resto das tropas nele e em pequenos
   deslocamentos ao redor (cada um também verificado).
5. **Zonas proibidas para toque:** barra de tropas, botão de encerrar/render-se, chat, botões
   de UI — nunca tocar ali.
6. **Limite de segurança:** máximo de N toques / X segundos sem sucesso → registrar no log,
   sair do ataque e seguir para a próxima conta.
7. (Opcional, depois) Guardar os pontos que funcionaram por distrito para acelerar os próximos ataques.

## Reaproveitado do PH Mod

- Troca de contas / Supercell ID (`SwitchAccount.au3`).
- Navegação na Capital (`SwitchToClanCapital`, `SwitchToMainVillage` em `ClanCapital.au3`).
- Coleta e doação de Capital Gold (`CollectCCGold`, `DonateCapitalTreasury`).
- Fechar/reabrir o jogo (`CloseCoC`).
- Leitura da quantidade de tropas na barra (OCR em `getOcr.au3`).

## A construir

- Entrar no clã por tag / sair do clã.
- Ataque no raid (seleção de distrito, drop com busca de ponto, verificação da barra).
- Orquestrador Raid Rotation + GUI (papel por perfil, tag do clã, limite, log).

## Perguntas em aberto

1. Visitantes CV6 estão sem clã hoje ou precisam voltar a outro clã depois?
2. O clã alvo é aberto (entrada direta)?
