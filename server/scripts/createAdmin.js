import 'dotenv/config'
import supabase from '../src/config/supabase.js'

const createAdmin = async () => {
  try {
    const { data, error } = await supabase.auth.admin.createUser({
      email: 'admin@yourapp.com',
      password: 'StrongPassword123!',
      email_confirm: true
    })

    if (error) throw error

    const { error: profileError } = await supabase
      .from('profiles')
      .insert({
        id: data.user.id,
        role: 'ADMIN',
        full_name: 'Super Admin',
        is_active: true
      })

    if (profileError) throw profileError

    console.log('✅ Admin created successfully')
    process.exit(0)

  } catch (err) {
    console.error('❌ Failed to create admin:', err.message)
    process.exit(1)
  }
}

createAdmin()
