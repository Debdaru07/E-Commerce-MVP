import { Router } from 'express'
import {
  signupConsumer,
  loginConsumer
} from '../controllers/consumer.controller.js'

const router = Router()

router.post('/signup', signupConsumer)
router.post('/login', loginConsumer)

export default router
