import supabase from '../../config/supabase.js'

export const signupDealer = async (req, res) => {
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
        role: 'DEALER',
        full_name,
        is_active: true
      })

    if (profileError) throw profileError

    res.status(201).json({ message: 'Dealer registered successfully' })
  } catch (err) {
    res.status(400).json({ error: err.message })
  }
}

export const loginDealer = async (req, res) => {
  res.json({ message: 'Dealer login TODO' })
}
