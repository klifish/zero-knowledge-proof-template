const { expect } = require("chai");

describe('MyAccount Smart Contract', function () {
    let entryPoint;

    before(async () => {
        const EntryPointFactoryContract = await ethers.getContractFactory("EntryPointFactory");
        entryPointFactory = await EntryPointFactoryContract.deploy();

        entryPointFactoryAddress = await entryPointFactory.getAddress();
    });

    it("Should deploy the EntryPoint", async () => {
        const EntryPointFactoryContract = await ethers.getContractFactory("EntryPointFactory");
        entryPointFactory = await EntryPointFactoryContract.deploy();

        try {
            const tx = await entryPointFactory.deployEntryPoint();
            const receipt = await tx.wait();

            const filter = entryPointFactory.filters.EntryPointDeployed();
            const events = await entryPointFactory.queryFilter(filter);
            expect(events.length).to.be.equal(1);
            expect(events[0].args.entryPointAddress).to.be.a.properAddress;
        } catch (error) {
            console.log('error', error);
        }
    });
});