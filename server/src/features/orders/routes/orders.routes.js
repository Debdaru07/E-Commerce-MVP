import { Router } from 'express'

const router = Router()

/**
 * Place a new order (Consumer)
 */
router.post('/', async (req, res) => {
  res.json({ message: 'Place order route working' })
})

/**
 * Get orders of logged-in consumer
 */
router.get('/my', async (req, res) => {
  res.json({ message: 'Get consumer orders route working' })
})

export default router
