let Bet = artifacts.require("Bet");

contract('Bet', async (accounts) => {
    it("should set initial reward pool 0", async () => {
        let instance = await Bet.deployed();
        let balance = await instance.rewardPool.call();
        assert.equal(balance.valueOf(), 0);
    });
    it("should deposit 10 wei to option 0, and 1000 wei to option 1", async () => {
        let instance = await Bet.deployed();
        await instance.deposit.sendTransaction(0, {from: accounts[1], value: 10});
        await instance.deposit.sendTransaction(1, {from: accounts[2], value: 1000});
        let option0 = await instance.options.call(0);
        let option1 = await instance.options.call(1);
        let rewardPool = await instance.rewardPool.call();
        assert.equal(option0[1].valueOf(), 10);
        assert.equal(option1[1].valueOf(), 1000);
        assert.equal(rewardPool, 1010);
    });
    it("should now allow do the bet again for accounts[1]", async () => {
        let instance = await Bet.deployed();
        try{
            await instance.deposit.sendTransaction(0, {from: accounts[1], value: 10});
        } catch(e) {
            assert.include(e.message, 'revert', 'Cant deposit');
        }
    });
    it("should return option course as int", async () => {
        let instance = await Bet.deployed();
        let course0 = await instance.getCourse.call(0);
        let course1 = await instance.getCourse.call(1);
        assert.equal(course0.valueOf(), 10100);
        assert.equal(course1.valueOf(), 101);
    });
});
