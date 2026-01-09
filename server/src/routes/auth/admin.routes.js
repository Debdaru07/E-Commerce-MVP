import { Router } from 'express'

const router = Router()

/**
 * ADMIN LOGIN ONLY
 * No signup route (as per design)
 */
router.post('/login', async (req, res) => {
  res.json({ message: 'Admin login route working' })
})

export default router
