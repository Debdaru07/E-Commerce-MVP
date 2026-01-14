import { Router } from 'express'
import { verifyToken } from '../middleware/auth.js'

const router = Router()

/**
 * Add product to wishlist
 */
router.post('/', verifyToken, async (req, res) => {
  const { product_id } = req.body
  const userId = req.user.id

  if (!product_id) {
    return res.status(400).json({ error: 'product_id is required' })
  }

  const { error } = await supabase
    .from('wishlist')
    .insert({
      user_id: userId,
      product_id
    })

  if (error) {
    return res.status(400).json({ error: error.message })
  }

  res.status(201).json({ message: 'Added to wishlist' })
})

export default router
