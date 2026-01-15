import supabase from '../../config/supabase.js'

export const signupConsumer = async (req, res) => {
  const { email, password, full_name } = req.body

  try {
    const { data: authData, error: authError } =
      await supabase.auth.admin.createUser({
        email,
        password,
        email_confirm: true
      })

    if (authError) throw authError

    const { error: profileError } = await supabase
      .from('profiles')
      .insert({
        id: authData.user.id,
        role: 'CONSUMER',
        full_name,
        is_active: true
      })

    if (profileError) throw profileError

    res.status(201).json({ message: 'Consumer registered successfully' })
  } catch (err) {
    res.status(400).json({ error: err.message })
  }
}

export const loginConsumer = async (req, res) => {
  res.json({ message: 'Consumer login TODO' })
}
