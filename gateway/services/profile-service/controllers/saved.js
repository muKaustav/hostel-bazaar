const SavedModel = require('../models/saved')

let createSaved = (req, res) => {
    let userId = req.user._id

    SavedModel.findOne({ userId: userId })
        .exec((err, saved) => {
            if (err) {
                res.send(err)
            } else {
                if (!saved) {
                    let newSaved = new SavedModel({
                        userId: userId
                    })

                    newSaved.save((err, saved) => {
                        if (err) {
                            res.send(err)
                        } else {
                            res.send(saved)
                        }
                    })
                } else {
                    res.send(saved)
                }
            }
        })
}

let getSaved = (req, res) => {
    let userId = req.user._id

    SavedModel.find({ userId: userId })
        .populate('items.product')
        .exec((err, saved) => {
            if (err) {
                res.send(err)
            } else {
                res.send(saved)
            }
        })
}

let addSaved = async (req, res) => {
    try {
        let userId = req.body.userId

        const saved = await SavedModel.findOne({ userId: userId })

        if (!saved) {
            return res.status(404).json({ message: 'Saved document not found' })
        }

        const { itemId } = req.body

        const itemExists = saved.items.some(i => i.product.toString() === itemId.toString())

        if (itemExists) {
            return res.status(400).json({ message: 'Item already exists in saved items', saved })
        }

        saved.items.push({ product: itemId })

        await saved.save()

        return res.status(200).json({ message: 'Item added to saved items', saved })
    } catch (error) {
        return res.status(500).json({ message: 'Error adding item to saved items', error })
    }
}

let removeSaved = async (req, res) => {
    try {
        const userId = req.user._id

        const saved = await SavedModel.findOne({ userId: userId })

        if (!saved) {
            return res.status(404).json({ message: 'Saved document not found' })
        }

        const { itemId } = req.body

        saved.items = saved.items.filter(i => i.product.toString() !== itemId.toString())

        await saved.save()

        return res.status(200).json({ message: 'Item removed from saved items', saved })
    } catch (error) {
        return res.status(500).json({ message: 'Error removing item from saved items', error })
    }
}

module.exports = { createSaved, getSaved, addSaved, removeSaved }