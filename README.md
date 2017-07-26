# Arcomp

## Usage
1. Baixar a pasta utilizada na disciplina, com os arquivos do Irvine e do MASM
	- Também disponível nesse repositório, sob o nome `Irvine.zip`, e já com os passos 3 e 4 executados.
2. Descompactar na pasta _C:\Irvine_
3. Mover o conteúdo de _C:\Irvine\MASM_ para _C:\Irvine_
4. **(opcional)** Deletar os arquivos _C:\Irvine\cmd.exe.lnk_ e _C:\Irvine\asm32.bat_
5. Clonar esse repositório em _C:\Irvine\arcomp_
6. Invocar `asm32 main`

Obs: `asm32 /D main` também invoca o windbg, assim como nas aulas.

Obs 2: Para invocar o `asm32` sem a flag `/D` é necessário comentar a `int 3` no arquivo `main.asm`.

Obs 3: Para executar o jogo de duplo click no main.exe. Não abra pelo terminal o main.exe pois ele fica desconfigurado.
