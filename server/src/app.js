import express from 'express'
import cors from 'cors'

import consumerRoutes from './routes/auth/consumer.routes.js'
import dealerRoutes from './routes/auth/dealer.routes.js'
import adminRoutes from './routes/auth/admin.routes.js'

import productRoutes from './routes/products.routes.js'
import orderRoutes from './routes/orders.routes.js'
import wishlistRoutes from './routes/wishlist.routes.js'

const app = express()

app.use(cors())
app.use(express.json())

app.use('/auth/consumer', consumerRoutes)
app.use('/auth/dealer', dealerRoutes)
app.use('/auth/admin', adminRoutes)

app.use('/products', productRoutes)
app.use('/orders', orderRoutes)
app.use('/wishlist', wishlistRoutes)

export default app
