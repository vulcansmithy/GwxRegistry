class WalletSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  attributes :wallet_address,
             :encrypted_pk,
             :encrypted_pk_iv
end
