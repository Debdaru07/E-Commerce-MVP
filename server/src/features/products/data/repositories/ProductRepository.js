import supabase from '../../../../shared/database/supabase.js'
import { IProductRepository } from '../../domain/interfaces/IProductRepository.js'
import { ProductMapper } from '../mappers/ProductMapper.js'

/**
 * Product Repository Implementation - Data Layer
 * Implements the IProductRepository interface using Supabase
 */
export class ProductRepository extends IProductRepository {
  /**
   * Find all active products with optional filters
   * @param {Object} filters - Filter criteria
   * @returns {Promise<Product[]>}
   */
  async findAll(filters = {}) {
    let query = supabase
      .from('products')
      .select('*')
      .eq('is_active', true)

    if (filters.title) {
      query = query.ilike('title', `%${filters.title}%`)
    }

    if (filters.description) {
      query = query.ilike('description', `%${filters.description}%`)
    }

    if (filters.category) {
      query = query.eq('category_id', filters.category)
    }

    if (filters.sortBy && filters.order) {
      query = query.order(filters.sortBy, { ascending: filters.order === 'asc' })
    } else {
      query = query.order('created_at', { ascending: false })
    }

    const { data, error } = await query

    if (error) throw error

    return data.map(row => ProductMapper.toEntity(row))
  }

  /**
   * Find product by ID
   * @param {string} id - Product ID
   * @returns {Promise<Product|null>}
   */
  async findById(id) {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('id', id)
      .single()

    if (error) {
      if (error.code === 'PGRST116') return null // Not found
      throw error
    }

    return ProductMapper.toEntity(data)
  }

  /**
   * Find products by dealer ID
   * @param {string} dealerId - Dealer ID
   * @returns {Promise<Product[]>}
   */
  async findByDealerId(dealerId) {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('dealer_id', dealerId)
      .order('created_at', { ascending: false })

    if (error) throw error

    return data.map(row => ProductMapper.toEntity(row))
  }

  /**
   * Create a new product
   * @param {Object} productData - Product data
   * @returns {Promise<Product>}
   */
  async create(productData) {
    const { data, error } = await supabase
      .from('products')
      .insert(productData)
      .select()
      .single()

    if (error) throw error

    return ProductMapper.toEntity(data)
  }

  /**
   * Update an existing product
   * @param {string} id - Product ID
   * @param {Object} updateData - Update data
   * @returns {Promise<Product>}
   */
  async update(id, updateData) {
    const { data, error } = await supabase
      .from('products')
      .update(updateData)
      .eq('id', id)
      .select()
      .single()

    if (error) throw error

    return ProductMapper.toEntity(data)
  }

  /**
   * Delete a product
   * @param {string} id - Product ID
   * @returns {Promise<boolean>}
   */
  async delete(id) {
    const { data, error } = await supabase
      .from('products')
      .delete()
      .eq('id', id)
      .select()

    if (error) throw error

    return data && data.length > 0
  }
}