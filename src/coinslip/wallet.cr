require "./redeem_request"

module Coinslip
  abstract class Wallet
    abstract def pay(redeem_request : RedeemRequest)
    abstract def payed?(redeem_request : RedeemRequest)
    abstract def subscribe(redeem_request : RedeemRequest)
  end
end
