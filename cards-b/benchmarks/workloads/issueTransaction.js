/*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');
const { loadSync } = require('protobufjs');
const base64 = require("byte-base64");
const faker = require('faker');

/**
 * Workload module for the benchmark round.
 */
class IssueTransactionWorkload extends WorkloadModuleBase {

    /**
     * Initializes the workload module instance.
     */
    constructor() {
        super();
        this.contractId = '';
        this.contractVersion = '';
        this.protobuf = loadSync("../proto/cards-contract.proto")
        this.CardIssueRequest = this.protobuf.lookupType("org.dangerousplay.hyperledger.CardTransactionRequest")
    }

    /**
     * Initialize the workload module with the given parameters.
     * @param {number} workerIndex The 0-based index of the worker instantiating the workload module.
     * @param {number} totalWorkers The total number of workers participating in the round.
     * @param {number} roundIndex The 0-based index of the currently executing round.
     * @param {Object} roundArguments The user-provided arguments for the round from the benchmark configuration file.
     * @param {ConnectorBase} sutAdapter The adapter of the underlying SUT.
     * @param {Object} sutContext The custom context object provided by the SUT adapter.
     * @async
     */
    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);

        const args = this.roundArguments;
        this.contractId = args.contractId;
        this.contractVersion = args.contractVersion;
    }

    /**
     * Assemble TXs for the round.
     * @return {Promise<TxStatus[]>}
     */
    async submitTransaction() {
        /*
        * message CardTransactionRequest {
  string authTransactionType = 1;
  string plasticId = 2;
  int64 accountId = 3;
  string merchantName = 6;
  string merchantCity = 7;
  string issuerAmount = 8;
  string acquirerAmount = 9;
  string iofAmount = 10;
  string transactionProcessingType = 11;
  bool national = 12;
  string lastDigits = 13;
  string issuerCurrencyCode = 14;
  string acquirerCurrencyCode = 15;
  PosEntryMode posEntryMode = 16;
}
        * */

        const amount = faker.finance.amount()

        const request = this.CardIssueRequest.create({
            authTransactionType: "",
            plasticId: "",
            accountId: faker.finance.account(),
            merchantName: faker.company.companyName(),
            merchantCity: faker.address.city(),
            issuerAmount: amount.toString(),
            acquirerAmount: faker.finance.amount(0, amount).toString(),
            iofAmount: "",
            transactionProcessingType: "",
            national: true,
            lastDigits: faker.finance.creditCardNumber(),
            issuerCurrencyCode: faker.finance.currencyCode(),
            acquirerCurrencyCode: faker.finance.currencyCode()
        });

        const bytes = this.CardIssueRequest.encode(request).finish();

        const myArgs = {
            contractId: this.contractId,
            contractFunction: 'issueTransaction',
            contractArguments: [base64.bytesToBase64(bytes)],
            readOnly: false
        };

        return this.sutAdapter.sendRequests(myArgs);
    }
}

/**
 * Create a new instance of the workload module.
 * @return {WorkloadModuleInterface}
 */
function createWorkloadModule() {
    return new IssueTransactionWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
