import { useState, useEffect } from 'react'
import Header from '@/components/layouts/header'
import useMovie from '@/hooks/movie/userMovie'
import BasePagination from '@/components/ui_parts/pagination/base_pagination'
import { userAuth } from '@/store'
import { useRecoilValue, useSetRecoilState } from 'recoil'
import socket from '@/channels/socket'
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

export interface MovieParams {
  page?: number | string
}

const Home = () => {
  const [params, setParams] = useState<MovieParams>({})
  const { movies, meta } = useMovie({ params })
  const authToken = useRecoilValue(userAuth)

  useEffect(() => {
    if (authToken?.token) {
      socket(authToken?.token).subscriptions.create({
        channel: 'MoviesChannel'
      },{
        connected: () => console.log('connected success'),
        disconnected: () => console.log('disconnected'),
        received: (data) => {
          console.log('received new video', data);
          const message = `User ${data.email} shared a movie ${data.movie_title}`;
          toast.success(message);
        },
      })
    }
  }, [authToken?.token]);

  const handlePageChange = (page: number) => {
    setParams({
      ...params,
      page
    })
  }

  return <>
    <ToastContainer />
    <Header title='Funny Movies' />
    <div className='mt-10 flex flex-col items-center justify-items-center pb-32'>
    {
      movies.map((movie) => (
        <div className='flex mb-5 w-2/3' key={movie.id}>
          <div className='mr-5'>
            <iframe
              width='auto'
              height='255'
              src={`https://www.youtube.com/embed/${movie.youtube_id}`}
            />
          </div>
          <div className=''>
            <p className='font-bold text-red-700 text-[18px]'>{movie.title}</p>
            <p className='text-[16px]'>Shared by: {movie.user.email}</p>
            <p className='text-[16px]'>Description:</p>
            <p className='italic font-bold text-[12px]'>{movie.description}</p>
          </div>
        </div>
      ))
    }
    {meta && (
            <BasePagination
              className="!mt-[50px]"
              totalCount={meta.total_count}
              per={meta.per}
              currentPage={meta.page}
              onChange={(page) => handlePageChange(page)}
            />
          )}
    </div>
  </>
}

export default Home
