<script setup>
</script>

<template>
  <div class="alert">
    You need to have the ArgentX wallet installed as well as Metamask. It uses the Goerli network!
  </div> 
  <div v-if="userL2Address">
    <p> Current spawn rate : {{this.rate}} </p>
    <p> Attempts : {{this.attempts}} </p>
    <p><button @click="kill">Kill that monster!</button></p>
    <div v-if="hasItem == 2">
      <p>You got a magic axe! Sell it?</p>
      Price to sell at : <input v-model="inputs.sellingPrice" placeholder="0" /> <button @click="sell()">Sell</button>
    </div>
    <div v-if="hasItem == 1">
      <p>This lad didn't drop any magix axe... Better luck next time!</p>
    </div>
  </div>
  <div v-else>
    <p>You need to be connected with your ArgentX wallet.</p>
    <button @click="connectL2">Connect to Starknet</button>
  </div>
  <hr>

</template>

<script>
import { getStarknet } from "@argent/get-starknet";
import { compileCalldata, stark, number, Contract } from 'starknet';
const { getSelectorFromName } = stark;

import abi from '../assets/abi.json';

const L2_CONTRACT_ADDRESS = "0x056f7f4674b8d0cedd12ca3f6d511aeef0602a2fa6eef73ac032dfee417b0ed7";

export default {
  name: 'Main',
  data() {
    return {
      starknet : undefined,
      userL2Address : undefined,
      signer : undefined,
      hasItem : 0,
      contract : undefined,
      rate: 0,
      attempts : 0,
      inputs : {
        sellingPrice : undefined
      }
    }
  },
  methods : {
    async connectL2() {
      this.starknet = getStarknet({ showModal: true });
      const [userWalletContractAddress] = await this.starknet.enable(); // may throws when no extension is detected
      // check if connection was successful
      if(this.starknet.isConnected) {
        this.userL2Address = userWalletContractAddress;
        this.signer = this.starknet.account.signer;
        this.contract = new Contract(abi, L2_CONTRACT_ADDRESS, this.starknet.account);
      } else {
        // In case the extension wasn't successfully connected you still have access to a starknet.js Provider to read starknet states and sent anonymous transactions
        console.log("not connected!");
      }
    },
    async kill() {
      const result = await this.starknet.provider.callContract({
        contractAddress : L2_CONTRACT_ADDRESS,
        entrypoint : "getRate",
        calldata : []
      });
      this.rate = parseInt(result.result[0]) / 2**61;;
      if (Math.random() <= this.rate) {
          this.hasItem = 2;
          this.attempts = 0;
      } else {
          this.hasItem = 1;
          this.attempts+=1;
      }
    },
    async sell() {
      const tx = await this.contract.sell(this.inputs.sellingPrice);
      console.log(tx);
      this.inputs.sellingPrice = 0;
      this.hasItem = 0;
    }
  },
  mounted() {
    //
  }
}
</script>

<style scoped>
.alert {
  padding: 20px;
  background-color: #f44336; /* Red */
  color: white;
  margin-bottom: 15px;
}
</style>
