pushd console
java -Xms512M -Xmx1G -cp ".;./*;../libs/*" org.nem.console.Main %*
popd
