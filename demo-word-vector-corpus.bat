@echo off
call mvn -Dmaven.test.skip clean install dependency:copy-dependencies
set JAVA_OPTS=-Xms12000m -Xmx12000m
set CLASS_PATH=target/classes;target/dependency/slf4j-api-1.6.4.jar;target/dependency/logback-classic-0.9.28.jar;target/dependency/logback-core-0.9.28.jar
set EXECUTOR=java %JAVA_OPTS% -cp %CLASS_PATH%
rem 1、从语料库中提取词，词之间以空格分隔，内容保存到文件target/word.txt
call %EXECUTOR% org.apdplat.word.corpus.ExtractText target/word.txt
rem 2、对分好词的文件target/word.txt建立词向量，将词向量保存到文件target/vector.txt，将词汇表保存到文件target/vocabulary.txt
rem 上下文长度为
set CONTEXT_WINDOW_LENGTH=2
rem 词向量长度
set VECTOR_LENGTH=30
call %EXECUTOR% org.apdplat.word.vector.Word2Vector target/word.txt target/vector.txt target/vocabulary.txt %CONTEXT_WINDOW_LENGTH% %VECTOR_LENGTH%
rem 3、计算不同词向量之间的相似度，控制台编码为GBK
call %EXECUTOR% org.apdplat.word.vector.Distance target/vector.txt gbk