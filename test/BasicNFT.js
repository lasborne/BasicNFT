
const {ethers} = require('hardhat')
const {expect} = require('chai')

describe('NFT Contract', () => {
    let deployer, nftContract, user

    beforeEach(async() => {
        [deployer, user] = await ethers.getSigners()

        const NftContract = await ethers.getContractFactory('BasicNFT', deployer)
        nftContract = await NftContract.deploy()
    })

    describe('runs the NFT smart contract', () => {
        it('returns the BaseUri', async() => {
            const baseURI = await nftContract.baseURI()
            expect(baseURI).to.equal(
                'https://ipfs.io/ipfs/QmSrSwboxekwhUfK5nKcbzK6xuTmNxhsiz643pmjqJfqPt/'
            )
        })
        it('does the minting to the smart contract, and checks balance', async() => {
            const allMints = await nftContract.mintAll('0x', 21)
            console.log(allMints)
            console.log(`Deployer address: ${deployer.address}`)
            console.log(`Contract Address: ${nftContract.address}`)
            console.log(Number(await nftContract.totalSupply()))
            const balance = await nftContract.balanceOf(deployer.address)
            expect(balance).to.eq(21)
        })
        // Intentional failed test
        /*it('checks if only the contract deployer is allowed to mintAll', async() => {
            console.log(`User address: ${user.address}`)
            // This test should fail because another user tries caling the mintAll()
            // function
            await nftContract.connect(user).mintAll('0x', 21)
        })*/
    })
})