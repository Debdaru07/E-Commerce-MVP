import { Router } from 'express'
import { loginAdmin } from '../controllers/admin.controller.js'

const router = Router()


router.post('/login', loginAdmin)



/**
 * ADMIN LOGIN ONLY
 * No signup route (as per design)
 */
//router.post('/login', async (req, res) => {
  //res.json({ message: 'Admin login route working' })
//})

export default router
