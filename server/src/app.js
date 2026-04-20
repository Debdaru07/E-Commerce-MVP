import express from 'express'
import cors from 'cors'

import categoryRoutes from './features/category/routes/category.routes.js'
import consumerRoutes from './features/auth/routes/consumer.routes.js'
import dealerRoutes from './features/auth/routes/dealer.routes.js'
import adminRoutes from './features/auth/routes/admin.routes.js'
import cartRoutes from './features/cart/routes/cart.routes.js'
import productRoutes from './features/products/routes/products.routes.js'
import orderRoutes from './features/orders/routes/orders.routes.js'
import wishlistRoutes from './features/wishlist/routes/wishlist.routes.js'

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
