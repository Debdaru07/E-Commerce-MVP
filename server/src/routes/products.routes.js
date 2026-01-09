import { Router } from 'express'

const router = Router()

/**
 * Get all active products (Public / Consumer)
 */
router.get('/', async (req, res) => {
  res.json({ message: 'Get products route working' })
})

/**
 * Create product (Dealer)
 */
router.post('/', async (req, res) => {
  res.json({ message: 'Create product route working' })
})

/**
 * Update product (Dealer)
 */
router.put('/:id', async (req, res) => {
  res.json({ message: 'Update product route working' })
})

/**
 * Delete product (Dealer)
 */
router.delete('/:id', async (req, res) => {
  res.json({ message: 'Delete product route working' })
})

export default router
