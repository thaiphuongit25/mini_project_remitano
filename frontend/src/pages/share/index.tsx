// ** React Imports
import { ReactNode } from 'react'
import Form from '@/components/movies/form'
import Header from '@/components/layouts/header'
import DefaultLayout from '@/components/layouts/default_layout'
import withUserAuthentication from '@/hoc/withUserAuthentication'
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

const SharePage = withUserAuthentication(() => {
  return <>
    <Header title='Funny Movies' />
    <ToastContainer />
    <Form />
  </>
})

SharePage.getLayout = (page: ReactNode) => <><DefaultLayout>{page}</DefaultLayout></>

export default SharePage
