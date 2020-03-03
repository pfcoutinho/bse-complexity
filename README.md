# Blind source extraction (BSE) of images based on a complexity measure

Examples of blind source extraction (BSE) of images based on Kolmogorov-Chaitin complexity, which is estimated by means of lossless compression of data (in this case, the LZW compression of TIFF images). To perform the BSE, we assume that the mixtures are more complex (i.e., can be less compressed) than the source image. The contrast or score function, hereby named _complexity_, corresponds to the ratio of the file size of the compressed image to the file size of the same uncompressed image:

    complexity = file size of the compressed image / file size of the uncompressed image.

The scenario is as follows:

*_A_ is the full rank mixing matrix, which is given by:

    A = [cos(\phi)  -sin(\phi)
         sin(\phi)   cos(\phi)],

where _\phi_ is the mixing angle.

*w is the extraction vector:

    w = [cos(\theta)  sin(\theta)]^T,

in which _T_ indicates the transpose operation and \theta is in the interval [0, \pi].

Before applying the mixing process, the images are converted to 1-D arrays. Then, we have:

    x = A*s,

where _x_ corresponds to the mixed images and _s_ are the souces (one is the image of interest and the other is a noisy image). The extraction process is given by:

    y = w*x,

where _y_ is the recovered image.

A "darkening process" can be used to conceal the image of interest in the noise. As the darkening level increases, it becomes harder to spot the original image in the mixtures.

## Examples

### Example #1: QR Code

![BSE of the QR code.](imgs/results/qr-code-results.png)

**Figure 1** _Images of the QR code during the darkening, mixing, and extracting processes. The value of the complexity of the recovered image for each value of_ \theta _is right below. Observes that as the darkening levels increase, the source image is concealed in the noise._

### Example #2: @ sign

![BSE of the @ sign.](imgs/results/at-sign-results.png)

**Figure 2** _Images of the @ sign during the darkening, mixing, and extracting processes, and the complexity as a function of_ \theta.

### Example #3: Photography of the Mt. Fuji

![BSE of the photography of the Mt. Fuji.](imgs/results/mt-fuji-results.png)

**Figure 3** _Photography of the Mt. Fuji during the processes of mixing and extraction. The correspondent evolution of the complexity measure is shown below._

## References

P. Pajunen, "Blind source separation using algorithmic information theory", Neurocomputing, v. 22, 1-3, pp. 35-48, 1998. DOI: [doi.org/10.1016/S0925-2312(98)00048-4](https://doi.org/10.1016/S0925-2312(98)00048-4).

D. C. Soriano, R. Suyama, and R. Attux, "Blind extraction of chaotic sources from mixtures with stochastic signals based on recurrence quantification analysis", Digital Signal Processing, v. 21, 3, pp. 417-426, 2011. DOI: [doi.org/10.1016/j.dsp.2010.12.003](https://doi.org/10.1016/j.dsp.2010.12.003).

## License

See [LICENSE](LICENSE) for more information.

## Credits

All the credits for the photography of the Mt. Fuji goes to [かねのり 三浦](https://pixabay.com/pt/users/Kanenori-4749850/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2232246).

