import { Router } from 'express'

const router = Router()

/**
 * Add product to wishlist
 */
router.post('/:productId', async (req, res) => {
  res.json({ message: 'Add to wishlist route working' })
})

/**
 * Get wishlist of logged-in consumer
 */
router.get('/', async (req, res) => {
  res.json({ message: 'Get wishlist route working' })
})

/**
 * Remove product from wishlist
 */
router.delete('/:productId', async (req, res) => {
  res.json({ message: 'Remove from wishlist route working' })
})

export default router
