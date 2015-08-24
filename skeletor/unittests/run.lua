local thispath = select('1', ...):match(".+%.") or ""

require(thispath.."testSkeletorBasicLoading")
require(thispath.."testSkeletorBone")
require(thispath.."testSkeletorComplexLoading")
require(thispath.."testSkeletorDraw")
require(thispath.."testSkeletorGettersSetters")
require(thispath.."testSkeletorSkeleton")
require(thispath.."testUtils")
