import FungibleToken from Flow.FungibleToken
import Kibble from Project.Kibble

transaction(amount: UFix64) {
    let vaultRef: &Kibble.Vault

    prepare(signer: AuthAccount) {
        self.vaultRef = signer.borrow<&Kibble.Vault>(from: Kibble.VaultStoragePath)
        ?? panic("Could not borrow reference to the owner's Vault!")
    }

    execute {
       let burnVault <- self.vaultRef.withdraw(amount: amount)
       destroy burnVault
    }
}