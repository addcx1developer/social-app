import {
  downloadAndResize,
  DownloadAndResizeOpts,
  getResizedDimensions,
} from 'lib/media/manip'
import {manipulateAsync, SaveFormat} from 'expo-image-manipulator'
import {createDownloadResumable, deleteAsync} from 'expo-file-system'

describe('downloadAndResize', () => {
  const errorSpy = jest.spyOn(global.console, 'error')

  const mockResizedImage = {
    path: 'file://resized-image.jpg',
    size: 100,
    width: 100,
    height: 100,
    mime: 'image/jpeg',
  }

  beforeEach(() => {
    const mockedCreateResizedImage = manipulateAsync as jest.Mock
    mockedCreateResizedImage.mockResolvedValue({
      uri: 'file://resized-image.jpg',
      ...mockResizedImage,
    })
  })

  afterEach(() => {
    jest.clearAllMocks()
  })

  it('should return resized image for valid URI and options', async () => {
    const mockedFetch = createDownloadResumable as jest.Mock
    mockedFetch.mockReturnValue({
      cancelAsync: jest.fn(),
      downloadAsync: jest
        .fn()
        .mockResolvedValue({uri: 'file://resized-image.jpg'}),
    })

    const opts: DownloadAndResizeOpts = {
      uri: 'https://example.com/image.jpg',
      width: 100,
      height: 100,
      maxSize: 500000,
      mode: 'cover',
      timeout: 10000,
    }

    const result = await downloadAndResize(opts)
    expect(result).toEqual(mockResizedImage)
    expect(createDownloadResumable).toHaveBeenCalledWith(
      opts.uri,
      expect.anything(),
      {
        cache: true,
      },
    )
    expect(manipulateAsync).toHaveBeenCalledWith(expect.anything(), [], {
      format: SaveFormat.JPEG,
    })
    expect(manipulateAsync).toHaveBeenCalledWith(
      expect.anything(),
      [{resize: {height: opts.height, width: opts.width}}],
      {format: SaveFormat.JPEG, compress: 0.9},
    )
    expect(deleteAsync).toHaveBeenCalledWith(expect.anything())
  })

  it('should return undefined for invalid URI', async () => {
    const opts: DownloadAndResizeOpts = {
      uri: 'invalid-uri',
      width: 100,
      height: 100,
      maxSize: 500000,
      mode: 'cover',
      timeout: 10000,
    }

    const result = await downloadAndResize(opts)
    expect(errorSpy).toHaveBeenCalled()
    expect(result).toBeUndefined()
  })

  it('should return undefined for unsupported file type', async () => {
    const mockedFetch = createDownloadResumable as jest.Mock
    mockedFetch.mockReturnValue({
      cancelAsync: jest.fn(),
      downloadAsync: jest
        .fn()
        .mockResolvedValue({uri: 'file://downloaded-image'}),
    })

    const opts: DownloadAndResizeOpts = {
      uri: 'https://example.com/image',
      width: 100,
      height: 100,
      maxSize: 500000,
      mode: 'cover',
      timeout: 10000,
    }

    const result = await downloadAndResize(opts)
    expect(result).toEqual(mockResizedImage)
    expect(createDownloadResumable).toHaveBeenCalledWith(
      opts.uri,
      expect.anything(),
      {
        cache: true,
      },
    )
    expect(manipulateAsync).toHaveBeenCalledWith(expect.anything(), [], {
      format: SaveFormat.JPEG,
    })
    expect(manipulateAsync).toHaveBeenCalledWith(
      expect.anything(),
      [{resize: {height: opts.height, width: opts.width}}],
      {format: SaveFormat.JPEG, compress: 0.9},
    )
    expect(deleteAsync).toHaveBeenCalledWith(expect.anything())
  })
})

describe('produces correct new sizes for images', () => {
  it('should not downsize whenever dimensions are below the max dimensions', () => {
    const initialDimensionsOne = {
      width: 1200,
      height: 1000,
    }
    const resizedDimensionsOne = getResizedDimensions(initialDimensionsOne)

    const initialDimensionsTwo = {
      width: 1000,
      height: 1200,
    }
    const resizedDimensionsTwo = getResizedDimensions(initialDimensionsTwo)

    expect(resizedDimensionsOne).toEqual(initialDimensionsOne)
    expect(resizedDimensionsTwo).toEqual(initialDimensionsTwo)
  })

  it('should resize dimensions and maintain aspect ratio if they are above the max dimensons', () => {
    const initialDimensionsOne = {
      width: 3000,
      height: 1500,
    }
    const resizedDimensionsOne = getResizedDimensions(initialDimensionsOne)

    const initialDimensionsTwo = {
      width: 2000,
      height: 4000,
    }
    const resizedDimensionsTwo = getResizedDimensions(initialDimensionsTwo)

    expect(resizedDimensionsOne).toEqual({
      width: 2000,
      height: 1000,
    })
    expect(resizedDimensionsTwo).toEqual({
      width: 1000,
      height: 2000,
    })
  })
})
