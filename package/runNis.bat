pushd nis
java -Xms512M -Xmx1G -cp ".;./*;../libs/*" org.nem.deploy.CommonStarter
popd
