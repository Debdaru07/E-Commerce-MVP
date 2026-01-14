import { Router } from 'express'
import { protect } from '../middleware/auth.js'
import  supabase  from '../config/supabase.js'

const router = Router()

/**
 * ✅ GET CART (Logged-in consumer)
 */
router.get('/', protect, async (req, res) => {
  const { id: user_id } = req.user

const { data, error } = await supabase
  .from('cart_items')
  .select(`
    id,
    quantity,
    product:products!cart_items_product_id_fkey (
      id,
      title
    
    ),
    dealer:profiles!cart_items_dealer_id_fkey (
      id,
      full_name
    )
  `)
  .eq('user_id', user_id)



  if (error) return res.status(400).json({ error: error.message })

  res.json(data)
})

/**
 * ✅ ADD TO CART
 */
router.post('/', protect, async (req, res) => {
  const { id: user_id } = req.user
  const { product_id, dealer_id, quantity } = req.body

  // 1️⃣ Get product stock
  const { data: product, error: productError } = await supabase
    .from('products')
    .select('stock')
    .eq('id', product_id)
    .single()

  if (productError || !product) {
    return res.status(400).json({ error: 'Product not found' })
  }

  // 2️⃣ Check existing cart item
  const { data: existing } = await supabase
    .from('cart_items')
    .select('id, quantity')
    .eq('user_id', user_id)
    .eq('product_id', product_id)
    .single()

  const newQuantity = existing
    ? existing.quantity + quantity
    : quantity

  // 3️⃣ Stock validation
  if (newQuantity > product.stock) {
    return res.status(400).json({
      error: `Out of stock. Only ${product.stock} items available`
    })
  }

  // 4️⃣ Update or insert
  if (existing) {
    const { data, error } = await supabase
      .from('cart_items')
      .update({ quantity: newQuantity })
      .eq('id', existing.id)
      .select()
      .single()

    if (error) return res.status(400).json({ error: error.message })
    return res.json(data)
  }

  const { data, error } = await supabase
    .from('cart_items')
    .insert({
      user_id,
      product_id,
      dealer_id,
      quantity
    })
    .select()
    .single()

  if (error) return res.status(400).json({ error: error.message })

  res.status(201).json(data)
})


/**
 * ✅ UPDATE QUANTITY
 */
router.put('/:cartItemId', protect, async (req, res) => {
  const { cartItemId } = req.params
  const { quantity } = req.body

  // 1️⃣ Get cart item + product stock
  const { data: cartItem, error: cartError } = await supabase
    .from('cart_items')
    .select(`
      id,
      products!cart_items_product_id_fkey (
        stock
      )
    `)
    .eq('id', cartItemId)
    .single()

  if (cartError || !cartItem) {
    return res.status(404).json({ error: 'Cart item not found' })
  }

  const stock = cartItem.products.stock

  // 2️⃣ Validate stock
  if (quantity > stock) {
    return res.status(400).json({
      error: `Out of stock. Only ${stock} items available`
    })
  }

  // 3️⃣ Update quantity
  const { data, error } = await supabase
    .from('cart_items')
    .update({ quantity })
    .eq('id', cartItemId)
    .select()
    .single()

  if (error) return res.status(400).json({ error: error.message })

  res.json(data)
})


/**
 * ✅ REMOVE ITEM FROM CART
 */
router.delete('/:cartItemId', protect, async (req, res) => {
  const { cartItemId } = req.params

  const { error } = await supabase
    .from('cart_items')
    .delete()
    .eq('id', cartItemId)

  if (error) return res.status(400).json({ error: error.message })

  res.json({ message: 'Item removed from cart' })
})

/**
 * ✅ CLEAR CART (after order placed)
 */
router.delete('/', protect, async (req, res) => {
  const { id: user_id } = req.user

  const { error } = await supabase
    .from('cart_items')
    .delete()
    .eq('user_id', user_id)

  if (error) return res.status(400).json({ error: error.message })

  res.json({ message: 'Cart cleared' })
})

export default router
