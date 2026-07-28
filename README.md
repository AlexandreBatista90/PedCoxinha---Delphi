# Sistema de Pedidos de Coxinha

Este é um projeto desenvolvido em Delphi (VCL) focado no aprendizado e fixação de conceitos de banco de dados, regras de interface e integrações. O sistema gerencia o lançamento rápido de pedidos, filtragem de registros e agiliza a cobrança via PIX e envio de mensagens pelo WhatsApp.


## Funcionalidades Principais

* **Inclusão Rápida de Pedidos:**
  * Lançamento rápido de novos pedidos, com preenchimento automático de datas.
  * Validações de interface ao sair do campo (OnExit), bloqueando salvamentos vazios ou duplicidades, mas permitindo o cancelamento (botão Cancelar) sem travar a tela.
  * Botões de navegação dinâmicos que se ativam ou desativam conforme o estado do banco de dados (`dsInsert`, `dsEdit`, `dsBrowse`).

* **Busca e Filtro em Tempo Real:**
  * O DBGrid de exibição (conectado a uma `FDQuery`) é atualizado instantaneamente enquanto o usuário interage, sem afetar o registro que está sendo editado na `FDTable`.
  * Filtro automático pela maior data lançada assim que o sistema é aberto.

* **Módulo de Cobrança (PIX Estático):**
  * Geração de Payload PIX com valor dinâmico baseado no total do pedido.
  * Renderização de QR Code na tela (usando `DelphiZXingQRCode`) para leitura imediata pelo cliente.
  * Geração do código "PIX Copia e Cola" (Pix Estático).

* **Integração com WhatsApp (Duplo Formato):**
  * **Envio Externo (Gratuito):** Abre o navegador padrão do sistema operacional com a API do WhatsApp (`wa.me`) para mensagens de texto rápidas de cobrança.
  * **Envio Interno com Anexo (Gratuito):** Utiliza um navegador embarcado dentro do próprio sistema Delphi. O usuário pode clicar em um botão para "Colar" a imagem (da área de transferência) diretamente no chat web e enviar junto com o texto.

---

## 🛠️ Tecnologias e Componentes Utilizados

* **Linguagem / IDE:** Delphi 12 CE/ RAD Studio (VCL)
* **Banco de Dados:** Advantage Database Server (ADS) em modo Local.
* **Acesso a Dados:** FireDAC (`TFDConnection`, `TFDTable`, `TFDQuery`).
* **Lógicas de Banco aplicadas:** 
  * Separação entre Table (para edição) e Query (para listagem e busca).
* **Bibliotecas Externas:**
  * `uPixPayload` (Estruturação do código PIX).
  * `DelphiZXingQRCode` (Geração visual do QR Code).
* **Outros Componentes Visuais:** `TDBGrid`, `TDBEdit`, `TDBLookupComboBox`, `TDBNavigator`, manipulação da classe `Clipboard`.

---


*Desenvolvido para fins de aprendizado.*


---





