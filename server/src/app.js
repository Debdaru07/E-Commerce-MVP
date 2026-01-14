import express from 'express'
import cors from 'cors'

import categoryRoutes from './routes/category.routes.js'
import consumerRoutes from './routes/auth/consumer.routes.js'
import dealerRoutes from './routes/auth/dealer.routes.js'
import adminRoutes from './routes/auth/admin.routes.js'
import cartRoutes from './routes/cart.routes.js'
import productRoutes from './routes/products.routes.js'
import orderRoutes from './routes/orders.routes.js'
import wishlistRoutes from './routes/wishlist.routes.js'

const app = express()

// ✅ GLOBAL MIDDLEWARE (MUST COME FIRST)
app.use(cors())
app.use(express.json())

// ✅ DEBUG MIDDLEWARE (TEMP)
app.use((req, res, next) => {
  console.log('HEADERS:', req.headers['content-type'])
  console.log('BODY:', req.body)
  next()
})

// ✅ ROUTES
app.use('/auth/consumer', consumerRoutes)
app.use('/auth/dealer', dealerRoutes)
app.use('/auth/admin', adminRoutes)
app.use('/cart', cartRoutes)

app.use('/products', productRoutes)
app.use('/orders', orderRoutes)
app.use('/wishlist', wishlistRoutes)
app.use('/categories', categoryRoutes)


export default app
