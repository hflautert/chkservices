ChkServices
=====

Script que fica de olho nos serviços, e se algum falhar, recupera, e envia email para o sysadmin

Instalação
=====

wget https://raw.githubusercontent.com/surfingtux/chkservices/master/chkservices.sh
chmod +x chkservices.sh
mv chkservices.sh /usr/local/bin/

Configuração
=====

Alterar serviços e endereço de e-mail dentro do script. Agendar na crontab, para rodar de 2 em 2 minutos
crontab -e
#Checkar servicos a cada 2 minutos
*/2 * * * * /usr/local/bin/chkservices.sh

Pendências
=====

Rodar como serviço.
Adicionar configuração de tempo de intervalo entre checkagens.
