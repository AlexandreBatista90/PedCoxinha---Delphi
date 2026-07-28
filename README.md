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


<img width="869" height="618" alt="01" src="https://github.com/user-attachments/assets/bbd120a3-60d2-489b-8f16-a7bbd07c2053" />
<img width="977" height="666" alt="02" src="https://github.com/user-attachments/assets/41363570-e2a8-4bc5-ab75-16956aa9f6c5" />
<img width="1357" height="778" alt="03" src="https://github.com/user-attachments/assets/dd9dffbd-14ad-47f8-8b65-f7b3d350ff8d" />
<img width="1357" height="773" alt="04" src="https://github.com/user-attachments/assets/a2c3fa9e-06cc-490f-8375-e9234e8a8208" />
<img width="865" height="383" alt="05" src="https://github.com/user-attachments/assets/1967d2d3-d257-4e28-a8a5-dd53c25f61e5" />
<img width="862" height="612" alt="06" src="https://github.com/user-attachments/assets/960113f4-44c9-4eac-9733-bd32de57688f" />
<img width="859" height="620" alt="07" src="https://github.com/user-attachments/assets/db0585ce-a6cb-4cd4-a7d9-5d607aad8cb1" />
<img width="861" height="616" alt="08" src="https://github.com/user-attachments/assets/2842eee8-644a-48ab-bed6-7ae87f16c091" />


